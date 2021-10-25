#!/bin/bash

echo "[apps/satellite] Extracting rhasspy satellite virtual environment from docker image"

IMAGES_DIR=${BUILDROOT_DIR}/images
RHASSPY_OUT_DIR=${IMAGES_DIR}/persist_part/rhasspy
SRC_ROOT_DIR=$SKIFF_WORKSPACE_DIR/target
DOCKER_PLATFORM=linux/amd64

case $SKIFF_CONFIG in

  *"pi/0"*)
    DOCKER_PLATFORM=linux/arm/v6
    ;;

  *"pi/3"*)
    DOCKER_PLATFORM=linux/arm/v7
    ;;

  *"pi/4"*)
    DOCKER_PLATFORM=linux/arm64
    ;;

esac


# clear the output dir before docker extracts over it
rm -rf $RHASSPY_OUT_DIR

DOCKER_BUILDKIT=1 docker build --output type=local,dest=$RHASSPY_OUT_DIR --platform $DOCKER_PLATFORM $SKIFF_CURRENT_CONF_DIR/hooks

# hacks since buildroot python is at /usr/bin/python instead!
unlink $RHASSPY_OUT_DIR/bin/python
ln -s /usr/bin/python $RHASSPY_OUT_DIR/bin/python

# more hacks because soundfile doesn't load properly on buildroot...
cp $SKIFF_CURRENT_CONF_DIR/hooks/soundfile.py $RHASSPY_OUT_DIR/lib/python3.9/site-packages/soundfile.py

# disable mosquitto from starting at boot (rhasspy-supervisor/supervisord will start this if needed)
rm -f $SRC_ROOT_DIR/usr/lib/systemd/system/mosquitto.service

# hacks to get supervisor to actually work
unlink $SRC_ROOT_DIR/usr/lib/rhasspy || true
ln -s /mnt/persist/rhasspy $SRC_ROOT_DIR/usr/lib/rhasspy
