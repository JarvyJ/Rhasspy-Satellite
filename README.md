# Rhasspy Satellite Image - BETA
This repo contains code to build a standalone Rhasspy satellite image. It allows you to easily add a seconday Pi as a satellite image to your [Rhasspy](https://rhasspy.readthedocs.io) instance. Since the image is trying to be as lean as possible, the satellite is only setup to handle wakewords, and will have to offload everything else to the main Rhaspsy instance.  You just need to flash it, setup your networking, and start it up. From there, plug in your microphone, and [setup the satellite](https://rhasspy.readthedocs.io/en/latest/tutorials/#shared-mqtt-broker)!

Currently targetting Raspberry Pi 0W, 3, and 4.
It currently has all wakeword engines installed (TODO: verify that they all work...)

The Rhasspy Satellite image is built on top of the [Skiff platform](https://github.com/skiffos/skiffos) for embedded systems, and will one day be integrated with [Home Intent](https://homeintent.jarvy.io).

## Installation
The main way to install it is to grab the latest system image from the [Releases](https://github.com/JarvyJ/Rhasspy-Satellite/releases) page, and flash it to your Raspberry Pi. I recommend using the [Raspberry Pi Imager](https://www.raspberrypi.com/news/raspberry-pi-imager-imaging-utility/) with the "Custom" image option.

### Networking Setup
After flashing it, you can setup your networking config. All the networking lives in a folder called `skiff` on the `persist` partition.

TODO: finish how to setup a wifi connection.

### Hostname (optional)
You can sett the hostname of the device by writing it in plaintext inside `skiff/hostname` on the `persist` parititon.

### SSH Keys (optional)
If you want to be able to SSH into the satellite server, you will need to place your SSH public key in `skiff/keys` on the `persist` partition. Afterwards, you can ssh as root into the system.

## Updates
To update to the latest version, start off by backing up your `/skiff` folder to your computer. It should be on the `persist` volume. After backing up `/skiff` to your computer, you can flash the latest image to your SD card, and restore your `/skiff` folder to the `persist` partition. From there all you need to do is boot it back up and you should be on the latest version!

We may offer an OTA update option in the future.

## Docker Installation
We also provide a thinned down Rhasspy docker image that can be used as a satellite on a standalone machine. This is really just an artifact of the build process that we've made available. You can always find the latest version under [packages](https://github.com/JarvyJ/Rhasspy-Satellite/pkgs/container/rhasspy-satellite) from this page.

## Roadmap
Once more of the following are figured out, and things are stabilized, I'll consider it out of beta:

 - [X] ~~Get images auto built for Pi 0W, 3, and 4~~
 - [X] ~~Support more of the wakeword options~~
 - [ ] Figure out how internationalizaion should work (mostly for wakeword systems. Everything else will be handled by the main Rhasspy image).

Some research needs to go into the following to ensure it is possible and can run in an embedded environment

 - [ ] Integrate with Hermes LED Control
 - [ ] Create a default config that handles most of the setup? Everything except siteid, MQTT, and alternative wakeword.
 - [ ] Support some of the Pi HAT based mics (matrix voice, seed, etc)
 - [ ] OTA updates
