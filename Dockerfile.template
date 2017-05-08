FROM resin/%%RESIN_MACHINE_NAME%%-node

# Install apt deps
RUN apt-get clean && apt-get update && apt-get upgrade -y && apt-get install -y \
  wget \
  curl \
  apt-utils \
  build-essential \
  openssh-server \
  vim \
  raspberrypi-sys-mods \
  dnsmasq \
  samba \
  genisoimage \
  syslinux-common \
  pxelinux \
  && rm -rf /var/lib/apt/lists/*

# We need wimtools from debian unstable, but everything else (above) should be stable only
RUN echo "deb http://deb.debian.org/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
 && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default \
 && apt-get update && apt-get install -y -t unstable wimtools \
 && rm -rf /var/lib/apt/lists/* \
 && rm /etc/apt/sources.list.d/debian-unstable.list

# mkwinpeimg requires mkisofs, but for licensing reasons debian instead ships genisoimage
RUN ln -s /usr/bin/genisoimage /usr/local/bin/mkisofs

# Configure openssh
RUN mkdir /var/run/sshd \
 && echo 'root:resin' | chpasswd \
 && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Set up DHCP, TFTP, Samba and PXE
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY smb.conf /etc/samba/smb.conf
RUN mkdir -p /data/tftp/syslinux \
 && cp /usr/lib/syslinux/modules/bios/* /data/tftp/syslinux/ \
 && cp /usr/lib/syslinux/memdisk /data/tftp/ \
 && cp /usr/lib/PXELINUX/pxelinux.0 /data/tftp/

# App setup
WORKDIR /usr/src/app
COPY app ./

# Move to /
WORKDIR /

ENV INITSYSTEM on

# Start app
CMD ["bash", "/usr/src/app/start.sh"]
