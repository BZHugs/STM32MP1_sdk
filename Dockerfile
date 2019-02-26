FROM ubuntu:16.04

#Set variables
ENV SDK_ROOT=/root/STM32MPU_SDK

# Install extra package
RUN apt-get update

RUN apt-get install  -y sed wget curl cvs subversion git-core coreutils \
						unzip texi2html texinfo docbook-utils gawk python-pysqlite2 \
						diffstat help2man make gcc build-essential g++ desktop-file-utils \
						chrpath libxml2-utils xmlto docbook bsdmainutils iputils-ping cpio \
						python-wand python-pycryptopp python-crypto

RUN apt-get install  -y libsdl1.2-dev xterm corkscrew nfs-common \
						nfs-kernel-server device-tree-compiler mercurial \
						u-boot-tools libarchive-zip-perl

RUN apt-get install  -y ncurses-dev bc linux-headers-generic gcc-multilib \
						libncurses5-dev libncursesw5-dev lrzsz dos2unix \
						lib32ncurses5 repo libssl-dev

RUN apt-get install  -y default-jre

# Download the SDK
RUN mkdir -p $SDK_ROOT/tmp
RUN cd $SDK_ROOT/tmp && wget https://www.st.com/content/ccc/resource/technical/software/sw_development_suite/group0/32/5e/0d/c9/05/87/40/c0/stm32mp1dev_yocto_sdk/files/SDK-x86_64-stm32mp1-openstlinux-4.19-thud-mp1-19-02-20.tar.xz/jcr:content/translations/en.SDK-x86_64-stm32mp1-openstlinux-4.19-thud-mp1-19-02-20.tar.xz
RUN cd $SDK_ROOT/tmp && tar xvf en.SDK-x86_64-stm32mp1-openstlinux-4.19-thud-mp1-19-02-20.tar.xz

# Fix error with tar inside docker
# cf https://github.com/coreos/bugs/issues/1095#issuecomment-336872867
RUN apt-get install -y bsdtar && ln -sf $(which bsdtar) $(which tar)

# Run the SDK installation script
RUN chmod +x $SDK_ROOT/tmp/stm32mp1-openstlinux-4.19-thud-mp1-19-02-20/sdk/st-image-weston-openstlinux-weston-stm32mp1-x86_64-toolchain-2.6-openstlinux-4.19-thud-mp1-19-02-20.sh
RUN $SDK_ROOT/tmp/stm32mp1-openstlinux-4.19-thud-mp1-19-02-20/sdk/st-image-weston-openstlinux-weston-stm32mp1-x86_64-toolchain-2.6-openstlinux-4.19-thud-mp1-19-02-20.sh -y -d $SDK_ROOT

# Clean up
RUN rm -Rf $SDK_ROOT/tmp

# Starting up the SDK
RUN echo "source $SDK_ROOT/environment-setup-cortexa7t2hf-neon-vfpv4-openstlinux_weston-linux-gnueabi" >> /etc/bash.bashrc