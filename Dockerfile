FROM ubuntu:bionic AS builder
MAINTAINER stroopkoek/stroopwafel

ENV DEBIAN_FRONTEND noninteractive

#update and install required packages
RUN apt -y update && apt -y install wget curl net-tools jsvc procps libcap2 libcap2-bin && \
    mkdir -p /tmp/b/c \
             /opt/tplink/stroopwafel

WORKDIR /tmp/b

RUN wget -O - https://static.tp-link.com/2020/202001/20200116/Omada_Controller_v3.2.6_linux_x64.tar.gz > c.tar.gz && tar -zxf c.tar.gz -C ./c --strip-components=1 && \
    rm -rf c.tar.gz

WORKDIR /tmp/b/c

RUN chmod +x ./install.sh && yes | ./install.sh && rm -rf /tmp/b && \
    rm -f /opt/tplink/EAPController/data/db/journal/prealloc.0 \
          /opt/tplink/EAPController/data/db/journal/prealloc.1 \
          /opt/tplink/EAPController/data/db/journal/prealloc.2 \
          /opt/tplink/EAPController/data/db/journal/j._0 && \
   #prepare control.sh for rootless access
   sed -i 's/-root/-tplink/' /opt/tplink/EAPController/bin/control.sh && \
   sed -i -e '/()/! s/check_root_perms/#check_root_perms/;' /opt/tplink/EAPController/bin/control.sh && \
   sed -i 's#/var/run/${NAME}.pid#/var/run/tplink/${NAME}.pid#' /opt/tplink/EAPController/bin/control.sh && \
   echo tail -f /dev/null >> /opt/tplink/EAPController/bin/control.sh

COPY ./script/install.sh /opt/tplink/stroopwafel

#real build
FROM ubuntu:bionic
RUN apt -y update && \
    apt -y install curl net-tools jsvc procps libcap2 libcap2-bin && \
    apt -y upgrade && \
    apt clean all && \
    rm -rf /var/cache/apt /var/lib/apt/lists /usr/share/doc && \
    #create /opt/tplink directory + for the config that resides on disk
    mkdir -p /opt/tplink \
             /current_config/bin \
             /current_config/data \
             /current_config/keystore \
             /current_config/logs \
             /current_config/properties \
             /current_config/work

COPY --from=builder /opt/tplink /opt/tplink

RUN chmod +x /opt/tplink/stroopwafel/install.sh && /opt/tplink/stroopwafel/install.sh && rm /opt/tplink/stroopwafel/install.sh && \
    useradd -U -d /opt/tplink tplink

EXPOSE 8088 8043 27001/udp 27002 29810/udp 29811 29812 29813
ENTRYPOINT ["/bin/bash", "/opt/tplink/stroopwafel/docker_entrypoint.sh"]
CMD ["/opt/tplink/EAPController/bin/control.sh"]
HEALTHCHECK CMD curl -k --fail https://localhost:8043/login || exit 1
