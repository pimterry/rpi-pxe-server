#!/bin/bash
set -e

# Takes a path to a windows image on the command line
# - Builds a Windows PE image, puts it into tftp
# - Mounts the Windows image within the samba share
# - Sets up PXE to boot from the PE image

WINDOWS_IMAGE_PATH=$1

mkdir -p /data/public/windows-image
mount "$WINDOWS_IMAGE_PATH" /data/public/windows-image
mkwinpeimg --iso --windows-dir=/data/public/windows-image /data/tftp/winpe.iso

mkdir -p /data/tftp/pxelinux.cfg
cp /usr/src/app/windows/windows-pxeconfig /data/tftp/pxelinux.cfg/default

printf " ** All done! Connect this device to a target machine to boot into Windows PE ** \n"
printf " ** To install windows: `wpeinit`, `net use Q: \\192.168.0.1\public /user:root`, `Q:\windows-image\setup` ** \n
