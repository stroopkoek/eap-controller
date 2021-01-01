[![Docker Pulls](https://img.shields.io/docker/pulls/stroopwafel/eap-controller?style=for-the-badge)](https://hub.docker.com/r/stroopwafel/eap-controller)
[![Docker Stars](https://img.shields.io/docker/stars/stroopwafel/eap-controller?style=for-the-badge)](https://hub.docker.com/r/stroopwafel/eap-controller)
[![GitHub issues](https://img.shields.io/github/issues/stroopkoek/eap-controller?style=for-the-badge)](https://github.com/stroopkoek/eap-controller)
# Omada Controller
## Supported Architecture & Tags

Only x86-64 is supported at this time. I do have plans for an ARM version, but that will take some time.

| Tags | Description |
| :----: | --- |
| latest | Latest version of EAP Controller |
| 1.0 | Use version tags to stay at a certain release |

## Before upgrading to 4.1.5
[Upgrade Instructions](https://www.tp-link.com/en/omada-sdn/controller-upgrade)
tl:dr Backup your configuration and import it, after upgrading.

## Usage
I advise you to use the docker-compose.yml file to run EAP-controller. It will make your life easier. ;)

### Docker compose
Also available as a file in the repository.
```
---
version: "3"
services:
  eap:
    image: stroopwafel/eap-controller:latest
    container_name: eapcontroller
    volumes:
      - /path/to/your/folder:/current_config
    ports:
      - 8088:8088
      - 8043:8043
      - 27001:27001/udp
      - 27002:27002
      - 29810:29810/udp
      - 29811:29811
      - 29812:29812
      - 29813:29813
    restart: unless-stopped
```

### Docker run
```
docker run -p 8088:8088 -p 8043:8043 -p 27001:27001/udp \
-p 27002:27002 -p 29810:29810/udp -p 29811:29811 -p 29812:29812 \
-p 29813:29813 -v /path/to/your/config:/current_config \
--name=eapcontroller \
-d stroopwafel/eap-controller:latest
```

## Ports explanation
```
8088 8043   #used for accessing the management panel 8043:https 8088:http
27001/udp   #used for controller discovery
27002       #used for controller searching
29810/udp   #used for eap (AP) discovery
29811       #used for eap management
29812       #used for eap adaption
29813       #used for eap upgrades
```
The ports are _all_ important! Removing one of them and the EAP-controller will not work.

## Other flags
```
-v /path/to/your/config:/current_config #external:internalcontainer
   It's only necessary to change /path/to/your/config to a place where the container can store it's files.
   For example /mnt/mass_storage/eap-controller:/current_config
-d Run container in background and print container ID
```

## Versions
| Date | Tag | Description |
| --- | --- | ---|
| 01-01-2021 | 4.2.8 | EAP Controller v4.2.8 |
| 08-11-2020 | 4.1.5 | EAP Controller v4.1.5 |
| 13-06-2020 | 1.02 | EAP Controller v3.2.10 |
| 18-02-2020 | 1.01 | Initial release with EAP Controller v3.2.6 |
