## chmodding aswell to tpeap
cat <<-'EOF' > /opt/tplink/stroopwafel/stroopstart.sh
#!/bin/bash
#declaring variables
targetdirectory=/opt/tplink/EAPController

#look if configuration exists on disk, if there is any then import it, else don't really care
if [ -f /current_config/bin/control.sh ]; then
  echo "Found existing files; importing them to disk."
  ln -fs /current_config/bin $targetdirectory
  ln -fs /current_config/data $targetdirectory
  ln -fs /current_config/keystore $targetdirectory
  ln -fs /current_config/logs $targetdirectory
  ln -fs /current_config/properties $targetdirectory
  ln -fs /current_config/work $targetdirectory
else
  echo "Configuring new files"
fi

#starting tpeap service
/opt/tplink/EAPController/bin/control.sh start
tail -f /dev/null
EOF

chmod +x /opt/tplink/stroopwafel/stroopstart.sh
