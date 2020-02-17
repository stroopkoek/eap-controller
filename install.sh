## chmodding aswell to tpeap
cat <<-'EOF' > /opt/tplink/stroopwafel/docker_entrypoint.sh
#!/bin/bash
#declaring variables
targetdirectory=/opt/tplink/EAPController

#if /current_config/bin/control.sh doesn't exist then
#remove the current_config just in case and move the system folders to current_config
#else echo for logging purposes that existing files are found!
if ![ -f /current_config/bin/control.sh ]; then
  #remove current_config just in case; move the system folders to current_config
  #so that the link will work

  echo "Configuring new files; exporting them to volume"
  rm -rf /current_config/*
  mv ${targetdirectory}/bin /current_config/bin
  mv ${targetdirectory}/data /current_config/data
  mv ${targetdirectory}/keystore /current_config/keystore
  mv ${targetdirectory}/logs /current_config/logs
  mv ${targetdirectory}/properties /current_config/properties
  mv ${targetdirectory}/work /current_config/work

else
  #nothing to do except symlinking in next block
  echo "Found existing files; importing them to disk."

fi

#symlink it to the EAP folder.
ln -fs /current_config/bin $targetdirectory
ln -fs /current_config/data $targetdirectory
ln -fs /current_config/keystore $targetdirectory
ln -fs /current_config/logs $targetdirectory
ln -fs /current_config/properties $targetdirectory
ln -fs /current_config/work $targetdirectory

#starting tpeap service
/opt/tplink/EAPController/bin/control.sh start
tail -f /dev/null
EOF

chmod +x /opt/tplink/stroopwafel/docker_entrypoint.sh
