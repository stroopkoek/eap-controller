FROM ubuntu:bionic AS buildmonkey
MAINTAINER stroopkoek/stroopwafel

ENV DEBIAN_FRONTEND noninteractive

#update and install required packages
RUN apt -y update && apt -y install wget curl net-tools jsvc procps


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
FROM ubuntu:bionic
RUN apt -y update && apt -y install curl net-tools jsvc procps && \
    apt clean all && \
    rm -rf /var/cache/apt /var/lib/apt/lists /usr/share/doc

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

ENTRYPOINT ["/opt/tplink/stroopwafel/stroopstart.sh" && tail -f /dev/null]
