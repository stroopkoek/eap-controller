# eap-controller

I advise you to use the docker-compose.yml file to run EAP-controller. It will make your life easier. ;)

To run it on your Docker host use the following run command
```
docker run -p 8088:8088 -p 8043:8043 -p 27001:27001/udp \
-p 27002:27002 -p 29810:29810/udp -p 29811:29811 -p 29812:29812 \
-p 29813:29813 -v /path/to/your/config:/current_config \
-it --rm stroopwafel/eap-controller:1.0
```
The ports are *all* important! Removing one of them and the EAP-controller will not work.
