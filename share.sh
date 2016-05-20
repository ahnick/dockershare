#!/bin/bash

# Script to link to a container's filesystem
# and expose out via the Samba share.

# Invoke this script via "docker exec"
# (e.g. docker exec dockershare share <container_name>)


MOUNT_PATH=/docker/aufs/mnt/

CONTAINER_ID=$(docker inspect --format {{.Id}} $1 2> /dev/null)
MOUNT_ID=$(cat /docker/image/aufs/layerdb/mounts/$CONTAINER_ID/mount-id 2> /dev/null)

if [[ $MOUNT_ID ]]; then
  ln -s $MOUNT_PATH/$MOUNT_ID /containers/$1
fi

if [ -d "/containers/$1" ]; then
  echo "Container $1 linked."
else
  echo "Linking failed for container $1."
fi
