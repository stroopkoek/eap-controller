## chmodding aswell to tpeap
cat <<-'EOF' > /opt/tplink/stroopwafel/docker_entrypoint.sh
#!/bin/bash
#declaring variables
targetdirectory=/opt/tplink/EAPController

#if /current_config/bin/control.sh doesn't exist then
#remove the current_config just in case and move the system folders to current_config
#else echo for logging purposes that existing files are found!
if ! [ -f /current_config/properties/eap.properties ]; then
  #remove current_config just in case; move the system folders to current_config
  #so that the link will work

  echo "Configuring new files; exporting them to volume"
  rm -rf /current_config/*
  mv ${targetdirectory}/data /current_config/data
  mv ${targetdirectory}/keystore /current_config/keystore
  mv ${targetdirectory}/logs /current_config/logs
  mv ${targetdirectory}/properties /current_config/properties
  mv ${targetdirectory}/work /current_config/work

else
  #remove files from system folder.
  echo "Found existing files; importing them to disk."
  rm -rf ${targetdirectory}/data \
         ${targetdirectory}/keystore \
         ${targetdirectory}/logs \
         ${targetdirectory}/properties \
         ${targetdirectory}/work
fi
#prepare environment for tplink user
mkdir -p /var/run/tplink
chown -R tplink:tplink /var/run/tplink
chown -R tplink:tplink /current_config
chown -R tplink:tplink $targetdirectory
chmod -R 775 /current_config
chmod -R 775 $targetdirectory

#symlink it to the EAP folder.
ln -fs /current_config/data $targetdirectory
ln -fs /current_config/keystore $targetdirectory
ln -fs /current_config/logs $targetdirectory
ln -fs /current_config/properties $targetdirectory
ln -fs /current_config/work $targetdirectory

#run CMD of Dockerfile
exec runuser -u tplink "$@" start
EOF
