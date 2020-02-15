FROM centos:7 AS buildmonkey
MAINTAINER stroopkoek/stroopwafel

ENV DEBIAN_FRONTEND noninteractive

#update and install required packages
RUN yum -y update && yum -y install wget curl net-tools jsvc chkconfig procps


#Prepare tmp directory
RUN mkdir -p /tmp/b/c \
             /opt/tplink/stroopwafel

COPY ./install.sh /opt/tplink/stroopwafel
WORKDIR /tmp/b

RUN wget -O - https://static.tp-link.com/2020/202001/20200116/Omada_Controller_v3.2.6_linux_x64.tar.gz > c.tar.gz && tar -zxf c.tar.gz -C ./c --strip-components=1 && \
    rm -rf c.tar.gz

WORKDIR /tmp/b/c

RUN chmod +x ./install.sh && yes | ./install.sh && rm -rf /tmp/b && \
   rm -f /opt/tplink/EAPController/data/db/journal/prealloc.1 \
         /opt/tplink/EAPController/data/db/journal/prealloc.2 \
         /opt/tplink/EAPController/data/db/journal/j._0

RUN cp /opt/tplink/EAPController/install.sh /opt/tplink/install.sh


#real build
FROM centos:7
RUN yum -y update && yum -y install curl net-tools jsvc procps && \
    yum clean all && \
    rm -rf /var/cache/yum

#create /opt/tplink directory + for the config that resides on disk
RUN mkdir -p /opt/tplink \
             /current_config/bin \
             /current_config/data \
             /current_config/keystore \
             /current_config/logs \
             /current_config/properties \
             /current_config/work

COPY --from=buildmonkey /opt/tplink /opt/tplink

RUN chmod +x /opt/tplink/stroopwafel/install.sh && /opt/tplink/stroopwafel/install.sh && rm /opt/tplink/stroopwafel/install.sh
