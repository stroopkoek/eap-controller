FROM fedora:31
MAINTAINER stroopkoek/stroopwafel

#Prepare tmp directory
WORKDIR /tmp/b
RUN wget -s https://static.tp-link.com/2020/202001/20200116/Omada_Controller_v3.2.6_linux_x64.tar.gz > c.tar.gz
RUN tar -zxf c.tar.gz 

#update and install required packages
RUN dnf -y update && dnf clean all
RUN dnf -y install curl net-tools jsvc && dnf clean all






