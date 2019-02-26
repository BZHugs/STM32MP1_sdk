FROM ubuntu:16.04


ENV SDK_ROOT=/root/STM32MPU_workspace

RUN apt-get update \
    && apt-get install -y sed wget curl cvs subversion git-core coreutils unzip texi2html texinfo docbook-utils gawk python-pysqlite2 diffstat help2man make gcc build-essential g++ desktop-file-utils chrpath libxml2-utils xmlto docbook bsdmainutils iputils-ping cpio python-wand python-pycryptopp python-crypto \
    
    && apt-get install -y libsdl1.2-dev xterm corkscrew nfs-common nfs-kernel-server device-tree-compiler mercurial u-boot-tools libarchive-zip-perl \

    && apt-get install -y ncurses-dev bc linux-headers-generic gcc-multilib libncurses5-dev libncursesw5-dev lrzsz dos2unix lib32ncurses5 repo libssl-dev \
  
    && apt-get install -y default-jre

RUN mkdir -p $SDK_ROOT/tmp