Jelly Bean for Motorola Milestone2 (Android 4.1.1 AOSP)


Download:
=========

repo init -u git://github.com/tezet/android.git -b jellybean

repo sync


Download RomManager (DELETED BY OUR BUILD SYSTEM)
=================================================

mkdir -p vendor/cm/proprietary
cd vendor/cm && ./get-prebuilts

Build:
======

rm -rf out/target

For CM10 branch :
  source build/envsetup.sh && brunch milestone2

or for AOSP :
  source build/envsetup.sh && lunch full_milestone2-eng
  mka bacon

Use the signed zip to update the milestone2 with the bootmenu recovery, not the ota package !

