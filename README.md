# rpi-pxe-server
A ready-to-go PXE + TFTP network boot server for Raspberry Pi, with Resin deployment

Tested with:
* Raspberry Pi 3B
* Windows 10 iso from https://www.microsoft.com/es-es/software-download/windows10ISO

## Set up

1. Set up your device
2. Sign up for free on [resin.io](https://dashboard.resin.io/signup), create an application, and provision it with your wifi credentials.
3. Set the following environmental variables:
    - RESIN_SUPERVISOR_DELTA: 1 // Enables deltas for updates keeping later changes quick
4. Clone/fork this repo, and push it to your resin.io application's repository.
5. Set up your PXE config over samba (to /tftp), SCP (to /data/tftp), or tftp by:
   1. Uploading your PXE bootable image
   2. Adding your PXE config at `pxelinux.cfg/default`
6. You're ready to go: put the device on the same network as the target machine (directly or through a router, as long as DHCP is disabled on the router), tell that target machine to boot from the network, and enjoy.

You can change and push a new Dockerfile if you want to update your device to do this differently, or for quick changes there's an SSH port exposed that allows root login with the default password of 'resin'.

### Windows example

For the specific Windows boot process this was tested with, scripts are included. See `app/windows/setup-windows-pxe.sh` in this repo (`/usr/src/app` on the device) for full details.

This script:
* Builds a Windows PE image from a full Windows image.
* Configures the Windows PE image to chainload, by sharing the full Windows image over Samba, and running it remotely on bootup.
* Make this Windows PE image bootable through PXE.

To run this script:
1. Copy a Windows iso across to the device, either via samba or scp.
2. SSH into the device
3. Run `/usr/src/app/windows/setup-windows-pxe.sh <path_to_full_windows_iso>`

Once this is complete, any machine attached to the device should now boot into the full Windows install process.

Note that it seems Microsoft's iso download process makes it easy to end up with corrupted iso's, which will typicall start up, but refuse to install. To check for this, run `md5sum` on your iso to get its md5, and google for the hash. Any valid official image should return a huge number of related results.

## Security

This setup has pretty much no security - **do not connect this device to any untrusted network (e.g. the public internet)**. Root SSH is set up with a default password, and file sharing services are configure with public read/write access to the image you will be booting from. That's super convenient and effective if the device is only connected to you, but it's trivial complete control of both the device and the machine you're booting from if anybody else can connect.

## Technical details

* Device will run as 192.168.0.1, and provide DHCP for the rest of the 255.255.255.0 range.
* DHCP and TFTP configuration are done with Dnsmasq, see `dnsmasq.conf` (`/etc/dnsmasq.conf` on device)
* TFTP is preconfigured for BIOS PXE, using files from `syslinux` and `pxelinux` (see `Dockerfile.template` for details).
* A samba share is available, see `smb.conf` (`/etc/smb.conf` on device)
* Direct SSH access is available to examine and change the device at runtime, or transfer files over SCP.

## Potential extensions:

I'm open to PRs for these, but I don't need them myself right now, so they won't happen without help.

- Preprepared config/scripts for other scenarios.
- Allow setting a BOOT_IMAGE_URL environmental variable for a URL to get the boot image from.
- UEFI boots. I don't know much about this, but I know this currently supports only BIOS PXE. I believe most current motherboards support this, sometimes with an option like `LAN Boot Rom`, but for very new machines/in future this may not be true.