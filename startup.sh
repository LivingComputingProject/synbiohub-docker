#!/bin/bash

# If the user mounts an incomplete or empty data directory (such as first startup), create some defaults:
if ! [ -d "/mnt/data/hub-config" ] ; then
  mkdir /mnt/data/hub-config
fi

if ! [ -e "/mnt/data/hub-config/config.json" ] ; then
  cp /opt/synbiohub/default-config.json /mnt/data/hub-config/config.json
fi

if ! [ -d "/mnt/data/mongodb" ] ; then
  mkdir /mnt/data/mongodb
fi

# Ensure files in the mounted volume have appropriate permissions
chown -R ubuntu:ubuntu /mnt/data/hub-config
chown -R mongodb:mongodb /mnt/data/mongodb


# Starts the database
/usr/sbin/service mongodb start
sleep 10

# Starts the hub once the database is up
cd /opt/synbiohub/ && su ubuntu -c "forever synbiohub.js" &

# A hack to keep the Docker image alive, since the above are forked
tail -f /dev/null

