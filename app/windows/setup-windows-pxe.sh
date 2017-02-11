#!/bin/bash

# Takes a path to a windows image on the command line
# - Builds a Windows PE image, puts it into tftp
# - Mounts the Windows image within the samba share
# - Sets up PXE to boot from the PE image
# - Windows PE image script (start-pe.cmd) automatically uses samba share to start install

WINDOWS_IMAGE_PATH=$1

mkdir -p /data/public/windows-image
mount "$WINDOWS_IMAGE_PATH" /data/public/windows-image
mkwinpeimg --iso --windows-dir=/data/public/windows-image --start-script=start-pe.cmd /data/tftp/winpe.iso

mkdir -p /data/tftp/pxelinux.cfg
cp windows-pxeconfig /data/tftp/pxelinux.cfg/default