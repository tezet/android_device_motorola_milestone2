#include <linux/module.h>
#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/gpio_event.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <mach/gpio.h>
#include <linux/earlysuspend.h>
#include <linux/wakelock.h>
#include <plat/board-mapphone.h>

#define PREFIX "debounce: "

#define PADCONF_PULL_UP		( OMAP343X_PADCONF_OFF_WAKEUP_ENABLED | \
				OMAP343X_PADCONF_INPUT_ENABLED | \
				OMAP343X_PADCONF_PULL_UP | \
				OMAP343X_PADCONF_PUD_ENABLED | \
				OMAP343X_PADCONF_MUXMODE4 )

#define PADCONF_PULL_DOWN	( OMAP343X_PADCONF_OFF_WAKEUP_ENABLED | \
				OMAP343X_PADCONF_INPUT_ENABLED | \
				OMAP343X_PADCONF_PULL_DOWN | \
				OMAP343X_PADCONF_PUD_ENABLED | \
				OMAP343X_PADCONF_MUXMODE4 )

#define OMAP_CTRL_REGADDR(reg)            (OMAP2_L4_IO_ADDRESS(OMAP343X_CTRL_BASE) + (reg))

static unsigned old_flags = 0;
static ktime_t old_debounce_delay;
static ktime_t old_settle_time;
static ktime_t old_poll_time;
static int (*old_sw_fixup)(int index);
static struct gpio_event_matrix_info *gpio_evmi = NULL;
static int hw_debounce = 0;
static int hw_debounce_time = 0;

struct gpio_event {
	struct gpio_event_input_devs *input_devs;
	const struct gpio_event_platform_data *info;
	struct early_suspend early_suspend;
	void *state[0];
};

struct gpio_kp {
	struct gpio_event_input_devs *input_devs;
	struct gpio_event_matrix_info *keypad_info;
	struct hrtimer timer;
	struct wake_lock wake_lock;
	int current_output;
	unsigned int use_irq:1;
	unsigned int key_state_changed:1;
	unsigned int last_key_state_changed:1;
	unsigned int some_keys_pressed:2;
	unsigned long keys_pressed[0];
};

static struct gpio_kp *gpio_kp_state = NULL;

static int find_ms2_dev(struct device *dev, void *data)
{
	if (!strncmp((char*)data, dev_name(dev), strlen((char*)data))) {
		printk(KERN_INFO PREFIX "Found it\n");
		return 1;
	}
	return 0;
}

/* hardware debounce: (time + 1) * 31us */
static void hw_debounce_set(int enable, int time) {
	int i;

	if (gpio_evmi == NULL)
		return;

	for (i = 0; i < gpio_evmi->ninputs; i++) {
		int gpio = gpio_evmi->input_gpios[i];

		if ((time != -1) && (time != hw_debounce_time) && hw_debounce) {
			printk(KERN_INFO PREFIX "Setting hardware debounce time for GPIO %d to %d (%dus)\n", gpio, time, (time+1)*31);
			omap_set_gpio_debounce_time(gpio, time);
		}

		if ((enable != -1) && (enable != hw_debounce)) {
			printk(KERN_INFO PREFIX "%sabling hardware debounce for GPIO %d\n", (enable?"En":"Dis"), gpio);
			omap_set_gpio_debounce(gpio, enable);
		}
	}
}

static void set_irq_types(void) {
	int err;
	unsigned int irq;
	unsigned long type;
	int i;

	if (gpio_evmi == NULL)
		return;

	switch (gpio_evmi->flags & (GPIOKPF_ACTIVE_HIGH|GPIOKPF_LEVEL_TRIGGERED_IRQ)) {
	default:
		type = IRQ_TYPE_EDGE_FALLING;
		break;
	case GPIOKPF_ACTIVE_HIGH:
		type = IRQ_TYPE_EDGE_RISING;
		break;
	case GPIOKPF_LEVEL_TRIGGERED_IRQ:
		type = IRQ_TYPE_LEVEL_LOW;
		break;
	case GPIOKPF_LEVEL_TRIGGERED_IRQ | GPIOKPF_ACTIVE_HIGH:
		type = IRQ_TYPE_LEVEL_HIGH;
		break;
	}

	printk(KERN_INFO PREFIX "Settinhg IRQ type to 0x%lx\n", type);

	for (i = 0; i < gpio_evmi->ninputs; i++) {

		err = irq = gpio_to_irq(gpio_evmi->input_gpios[i]);

		if (err < 0)
			return;

		err = set_irq_type(irq, type);
	}
}

static ssize_t show_debounce_delay(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%ld\n", (gpio_evmi->debounce_delay.tv.nsec / NSEC_PER_MSEC));
}

static void set_debounce_delay(long delay)
{
	if (gpio_evmi->debounce_delay.tv.nsec != delay * NSEC_PER_MSEC) {
		printk(KERN_INFO PREFIX "Changing debounce_delay\n");
		gpio_evmi->debounce_delay.tv.nsec = delay * NSEC_PER_MSEC;
		printk(KERN_INFO PREFIX "debounce_delay: %u\n", gpio_evmi->debounce_delay.tv.nsec);
	}

#if 0
	if (gpio_evmi->debounce_delay.tv.nsec != 0) {
		if (!(gpio_evmi->flags & GPIOKPF_DEBOUNCE)) {
			printk(KERN_INFO PREFIX "Activating debounce\n");
			gpio_evmi->flags |= GPIOKPF_DEBOUNCE;
		}
	} else {
		if (gpio_evmi->flags & GPIOKPF_DEBOUNCE) {
			printk(KERN_INFO PREFIX "Deactivating debounce\n");
			gpio_evmi->flags &= ~GPIOKPF_DEBOUNCE;
		}
	}
#endif
}

static ssize_t store_debounce_delay(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	long int delay;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%ld", &delay);
	set_debounce_delay(delay);

	return count;
}

static ssize_t show_settle_time(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%ld\n", (gpio_evmi->settle_time.tv.nsec / NSEC_PER_USEC));
}

static ssize_t store_settle_time(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	long int delay;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%ld", &delay);
	gpio_evmi->settle_time.tv.nsec = delay * NSEC_PER_USEC;

	return count;
}

static ssize_t show_poll_time(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%ld\n", (gpio_evmi->poll_time.tv.nsec / NSEC_PER_MSEC));
}

static ssize_t store_poll_time(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	long int delay;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%ld", &delay);
	gpio_evmi->poll_time.tv.nsec = delay * NSEC_PER_MSEC;

	return count;
}

static ssize_t show_flags(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "0x%x\n", gpio_evmi->flags);
}

static ssize_t store_flags(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flags;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "0x%x", &flags);

	printk(KERN_INFO PREFIX "flags: 0x%x\n", flags);

	gpio_evmi->flags = flags;

	return count;
}

static ssize_t show_debounce_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_DEBOUNCE) ? 1 : 0);
}

static ssize_t store_debounce_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_DEBOUNCE;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_DEBOUNCE;
	}

	return count;
}

static ssize_t show_remove_some_phantom_keys_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_REMOVE_SOME_PHANTOM_KEYS) ? 1 : 0);
}

static ssize_t store_remove_some_phantom_keys_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_REMOVE_SOME_PHANTOM_KEYS;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_REMOVE_SOME_PHANTOM_KEYS;
	}

	return count;
}

static ssize_t show_print_unmapped_keys_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_PRINT_UNMAPPED_KEYS) ? 1 : 0);
}

static ssize_t store_print_unmapped_keys_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_PRINT_UNMAPPED_KEYS;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_PRINT_UNMAPPED_KEYS;
	}

	return count;
}

static ssize_t show_print_mapped_keys_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_PRINT_MAPPED_KEYS) ? 1 : 0);
}

static ssize_t store_print_mapped_keys_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_PRINT_MAPPED_KEYS;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_PRINT_MAPPED_KEYS;
	}

	return count;
}

static ssize_t show_print_phantom_keys_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_PRINT_PHANTOM_KEYS) ? 1 : 0);
}

static ssize_t store_print_phantom_keys_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_PRINT_PHANTOM_KEYS;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_PRINT_PHANTOM_KEYS;
	}

	return count;
}

static ssize_t show_active_high_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_ACTIVE_HIGH) ? 1 : 0);
}

static ssize_t store_active_high_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;
	int i;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_ACTIVE_HIGH;
		for (i = 0x7a; i <= 0x88; i += 2) {
			__raw_writew(PADCONF_PULL_DOWN, OMAP_CTRL_REGADDR(i));
		}
	} else {
		gpio_evmi->flags &= ~GPIOKPF_ACTIVE_HIGH;
		for (i = 0x7a; i <= 0x88; i += 2) {
			__raw_writew(PADCONF_PULL_UP, OMAP_CTRL_REGADDR(i));
		}
	}

	set_irq_types();

	return count;
}

static ssize_t show_level_triggered_irq_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_LEVEL_TRIGGERED_IRQ) ? 1 : 0);
}

static ssize_t store_level_triggered_irq_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_LEVEL_TRIGGERED_IRQ;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_LEVEL_TRIGGERED_IRQ;
	}

	set_irq_types();

	return count;
}

static ssize_t show_drive_inactive_flag(struct device *dev, struct device_attribute *attr, char *buf)
{
	if (!gpio_evmi) 
		return -ENODEV;

	return snprintf(buf, PAGE_SIZE, "%u\n", (gpio_evmi->flags & GPIOKPF_DRIVE_INACTIVE) ? 1 : 0);
}

static ssize_t store_drive_inactive_flag(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	unsigned flag;

	if (!gpio_evmi) 
		return -ENODEV;

	sscanf(buf, "%u", &flag);

	if (flag) {
		gpio_evmi->flags |= GPIOKPF_DRIVE_INACTIVE;
	} else {
		gpio_evmi->flags &= ~GPIOKPF_DRIVE_INACTIVE;
	}

	return count;
}

static ssize_t show_hw_debounce(struct device *dev, struct device_attribute *attr, char *buf)
{
	return snprintf(buf, PAGE_SIZE, "%d\n", hw_debounce);
}

static ssize_t store_hw_debounce(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	int enable;

	sscanf(buf, "%d", &enable);

	if (enable) {
		hw_debounce_set(1, -1);
		hw_debounce = 1;
	}
	else {
		hw_debounce_set(-1, 0);
		hw_debounce_set(0, -1);
		hw_debounce = 0;
		hw_debounce_time = 0;
	}

	return count;
}

static ssize_t show_hw_debounce_time(struct device *dev, struct device_attribute *attr, char *buf)
{
	return snprintf(buf, PAGE_SIZE, "%d\n", hw_debounce_time);
}

static ssize_t store_hw_debounce_time(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	int time;

	sscanf(buf, "%d", &time);

	if ((time < 0) || (time > 0xff))
		return count;

	if (!hw_debounce)
		return count;

	hw_debounce_set(-1, time);
	hw_debounce_time = time;

	return count;
}

static DEVICE_ATTR(debounce_delay, (S_IRUGO | S_IWUGO), show_debounce_delay, store_debounce_delay);
static DEVICE_ATTR(settle_time, (S_IRUGO | S_IWUGO), show_settle_time, store_settle_time);
static DEVICE_ATTR(poll_time, (S_IRUGO | S_IWUGO), show_poll_time, store_poll_time);
static DEVICE_ATTR(flags, (S_IRUGO), show_flags, store_flags);
static DEVICE_ATTR(debounce_flag, (S_IRUGO | S_IWUGO), show_debounce_flag, store_debounce_flag);
static DEVICE_ATTR(remove_some_phantom_keys_flag, (S_IRUGO | S_IWUGO), show_remove_some_phantom_keys_flag, store_remove_some_phantom_keys_flag);
static DEVICE_ATTR(print_unmapped_keys_flag, (S_IRUGO | S_IWUGO), show_print_unmapped_keys_flag, store_print_unmapped_keys_flag);
static DEVICE_ATTR(print_mapped_keys_flag, (S_IRUGO | S_IWUGO), show_print_mapped_keys_flag, store_print_mapped_keys_flag);
static DEVICE_ATTR(print_phantom_keys_flag, (S_IRUGO | S_IWUGO), show_print_phantom_keys_flag, store_print_phantom_keys_flag);
static DEVICE_ATTR(active_high_flag, (S_IRUGO | S_IWUGO), show_active_high_flag, store_active_high_flag);
static DEVICE_ATTR(level_triggered_irq_flag, (S_IRUGO | S_IWUGO), show_level_triggered_irq_flag, store_level_triggered_irq_flag);
static DEVICE_ATTR(drive_inactive_flag, (S_IRUGO | S_IWUGO), show_drive_inactive_flag, store_drive_inactive_flag);
static DEVICE_ATTR(hw_debounce, (S_IRUGO | S_IWUGO), show_hw_debounce, store_hw_debounce);
static DEVICE_ATTR(hw_debounce_time, (S_IRUGO | S_IWUGO), show_hw_debounce_time, store_hw_debounce_time);

#if 0
static int debounce_fixup(int index)
{
	int ret;

	printk(KERN_INFO PREFIX "key_state_changed: %d, last_key_state_changed: %d, some_keys_pressed: %d\n",
		gpio_kp_state->key_state_changed,
		gpio_kp_state->last_key_state_changed,
		gpio_kp_state->some_keys_pressed);

	ret = old_sw_fixup(index);
	if (!ret)
		printk(KERN_INFO PREFIX "Index 0x%x ignored!\n", index);

	return ret;
}
#endif

static void debounce_release(struct device *dev)
{
}

static struct device debounce_device = {
	.init_name = "debounce",
	.release = debounce_release,
};

static int __init debounce_init(void)
{
	struct device *event_dev = NULL;
	struct platform_device *pdev = NULL;
	struct gpio_event_platform_data *gpio_epd;
	struct gpio_event_info *gpio_ei;
	struct gpio_event *gpio_e;
	int err = 0;
	int i;

	printk(KERN_INFO PREFIX "Searching for " GPIO_EVENT_DEV_NAME "...\n");
	
	event_dev = device_find_child(&platform_bus, GPIO_EVENT_DEV_NAME, find_ms2_dev);
	if (event_dev == NULL)
		return -ENODEV;
	
	pdev = container_of(event_dev, struct platform_device, dev);
	if (pdev == NULL)
		return -ENODEV;
	
	gpio_epd = (struct gpio_event_platform_data*)event_dev->platform_data;
	printk(KERN_INFO PREFIX "And there is a %s connected...\n", gpio_epd->name);
	if (strcmp(gpio_epd->name, "sholes-keypad"))
		return -ENODEV;

	gpio_ei = (struct gpio_event_info*)gpio_epd->info[0];
	gpio_evmi = container_of(gpio_ei, struct gpio_event_matrix_info, info);

	gpio_e = platform_get_drvdata(pdev);
	printk(KERN_INFO PREFIX "Number of states: %d\n", gpio_e->info->info_count);

	/* Search for correct gpio_event state */
	for (i = 0; i < gpio_e->info->info_count; i++) {
		if (gpio_e->info->info[i]->func == gpio_ei->func) {
			printk(KERN_INFO PREFIX "Keypad state: %d\n", i);
			gpio_kp_state = gpio_e->state[i];
		}
	}

	if (!gpio_kp_state) {
		printk(KERN_ERR PREFIX "Can't determine correct keypad state!\n");
		return -ENODEV;
	}

	printk(KERN_INFO PREFIX "kp_use_irq: %d\n", gpio_kp_state->use_irq);
#if 0
	gpio_kp_state->use_irq=0;
	hrtimer_start(&(gpio_kp_state->timer), gpio_evmi->poll_time, HRTIMER_MODE_REL);
	printk(KERN_INFO PREFIX "kp_use_irq: %d\n", gpio_kp_state->use_irq);
#endif

	err = device_register(&debounce_device);
	if (err) {
		return err;
	}

	err = device_create_file(&debounce_device, &dev_attr_debounce_delay);
	err = device_create_file(&debounce_device, &dev_attr_settle_time);
	err = device_create_file(&debounce_device, &dev_attr_poll_time);
	err = device_create_file(&debounce_device, &dev_attr_flags);
	err = device_create_file(&debounce_device, &dev_attr_debounce_flag);
	err = device_create_file(&debounce_device, &dev_attr_remove_some_phantom_keys_flag);
	err = device_create_file(&debounce_device, &dev_attr_print_unmapped_keys_flag);
	err = device_create_file(&debounce_device, &dev_attr_print_mapped_keys_flag);
	err = device_create_file(&debounce_device, &dev_attr_print_phantom_keys_flag);
	err = device_create_file(&debounce_device, &dev_attr_active_high_flag);
	err = device_create_file(&debounce_device, &dev_attr_level_triggered_irq_flag);
	err = device_create_file(&debounce_device, &dev_attr_drive_inactive_flag);
	err = device_create_file(&debounce_device, &dev_attr_hw_debounce);
	err = device_create_file(&debounce_device, &dev_attr_hw_debounce_time);

	printk(KERN_INFO PREFIX "settle_time: %u\n", gpio_evmi->settle_time.tv.nsec);
	printk(KERN_INFO PREFIX "poll_time: %u\n", gpio_evmi->poll_time.tv.nsec);
	printk(KERN_INFO PREFIX "debounce_delay: %u\n", gpio_evmi->debounce_delay.tv.nsec);
	printk(KERN_INFO PREFIX "flags: 0x%x\n", gpio_evmi->flags);

	old_debounce_delay = gpio_evmi->debounce_delay;
	old_settle_time = gpio_evmi->settle_time;
	old_poll_time = gpio_evmi->poll_time;
	old_flags = gpio_evmi->flags;
	old_sw_fixup = gpio_evmi->sw_fixup;

#if 0
	printk(KERN_INFO PREFIX "Registering fixup handler\n");
	gpio_evmi->sw_fixup = debounce_fixup;
#endif

	return 0;
}

static void __exit debounce_exit(void)
{
	int i;

	if (gpio_evmi) {
		if (gpio_evmi->debounce_delay.tv.nsec != old_debounce_delay.tv.nsec) {
			printk(KERN_INFO PREFIX "Restoring debounce_delay\n");
			gpio_evmi->debounce_delay = old_debounce_delay;
			printk(KERN_INFO PREFIX "debounce_delay: %u\n", gpio_evmi->debounce_delay.tv.nsec);
		}
		if (gpio_evmi->flags != old_flags) {
			printk(KERN_INFO PREFIX "Restoring flags\n");
			gpio_evmi->flags = old_flags;
			printk(KERN_INFO PREFIX "flags: 0x%x\n", gpio_evmi->flags);
			if (gpio_evmi->flags & GPIOKPF_ACTIVE_HIGH) {
				for (i = 0x7a; i <= 0x88; i += 2) {
					__raw_writew(PADCONF_PULL_DOWN, OMAP_CTRL_REGADDR(i));
				}
			} else {
				for (i = 0x7a; i <= 0x88; i += 2) {
					__raw_writew(PADCONF_PULL_UP, OMAP_CTRL_REGADDR(i));
				}
			}
			set_irq_types();
		}
		gpio_evmi->settle_time = old_settle_time;
		gpio_evmi->poll_time = old_poll_time;

		if (gpio_evmi->sw_fixup != old_sw_fixup) {
			printk(KERN_INFO PREFIX "Restoring fixup handler\n");
			gpio_evmi->sw_fixup = old_sw_fixup;
		}
	}
	hw_debounce_set(0, 0);
	device_remove_file(&debounce_device, &dev_attr_debounce_delay);
	device_remove_file(&debounce_device, &dev_attr_settle_time);
	device_remove_file(&debounce_device, &dev_attr_poll_time);
	device_remove_file(&debounce_device, &dev_attr_flags);
	device_remove_file(&debounce_device, &dev_attr_debounce_flag);
	device_remove_file(&debounce_device, &dev_attr_remove_some_phantom_keys_flag);
	device_remove_file(&debounce_device, &dev_attr_print_unmapped_keys_flag);
	device_remove_file(&debounce_device, &dev_attr_print_mapped_keys_flag);
	device_remove_file(&debounce_device, &dev_attr_print_phantom_keys_flag);
	device_remove_file(&debounce_device, &dev_attr_active_high_flag);
	device_remove_file(&debounce_device, &dev_attr_level_triggered_irq_flag);
	device_remove_file(&debounce_device, &dev_attr_drive_inactive_flag);
	device_remove_file(&debounce_device, &dev_attr_hw_debounce);
	device_remove_file(&debounce_device, &dev_attr_hw_debounce_time);
	device_unregister(&debounce_device);
}

module_init(debounce_init);
module_exit(debounce_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Michael Gernoth <michael@gernoth.net>");
