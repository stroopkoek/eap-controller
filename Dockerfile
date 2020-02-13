FROM fedora:31
MAINTAINER stroopkoek/stroopwafel

ENV DEBIAN_FRONTEND noninteractive

#update and install required packages
RUN dnf -y update && dnf -y install wget curl net-tools jsvc chkconfig procps --setopt=install_weak_deps=False && dnf autoremove && dnf clean all && rm -rf /var/cache/dnf


#Prepare tmp directory
RUN mkdir -p /tmp/b/c
WORKDIR /tmp/b

RUN wget -O - https://static.tp-link.com/2020/202001/20200116/Omada_Controller_v3.2.6_linux_x64.tar.gz > c.tar.gz && tar -zxf c.tar.gz -C ./c --strip-components=1 && \
    rm -rf c.tar.gz

WORKDIR /tmp/b/c

RUN chmod +x ./install.sh && yes | ./install.sh && rm -rf /tmp/b && \
    rm /opt/tplink/EAPController/data/db/journal/prealloc.1 \
    /opt/tplink/EAPController/data/db/journal/prealloc.2 \
    /opt/tplink/EAPController/data/db/journal/j._0
