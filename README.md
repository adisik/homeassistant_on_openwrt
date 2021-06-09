# Homeassistant on OpenWrt

This repo provides tools to install the latest version of Home Assistant that supports python 3.9 (2021.5.5)
on a system with OpenWrt 21.02 installed. It provides the reduced version of HA with only minimal list of components 
included. Additionally, it keeps MQTT and ZHA components as they are 
widely used with smart home solutions.

It is distributed with a shell script that downloads and installs everything that required for a clean start.

### Requirements:
- 120 MB storage space (256 recommended)
- 128 MB RAM
- OpenWrt 21.02 rc2 installed


## Xiaomi Gateway installation

Add the openlumi feed to gain access to a few precompiled python requirements.
Skip this step if you have already added this feed.

```sh
(! grep -q openlumi /etc/opkg/customfeeds.conf) && (
wget -q https://openlumi.github.io/openwrt-packages/public.key -O /tmp/public.key && 
opkg-key add /tmp/public.key && rm /tmp/public.key &&
echo 'src/gz openlumi https://openlumi.github.io/openwrt-packages/packages/21.02/arm_cortex-a9_neon' >> /etc/opkg/customfeeds.conf &&
echo "Feed added successfully!"
) || echo "Feed added already. Skip."
```

Then go to generic installation

## Generic installation
Then, download the installer and run it.

```sh
wget https://raw.githubusercontent.com/adisik/homeassistant_on_openwrt/main/ha_install_21_02.sh -O - | sh
```

## Additionally included the following Home Assistant components:

 - asuswrt
 - bluetooth_le_tracker
 - command_line
 - coronavirus
 - dhcp
 - file
 - filter    
 - ffmpeg
 - generic
 - homekit_controller
 - trace
 - local_ip
 - moon
 - min_max
 - onvif
 - panel_iframe
 - ping
 - remote
 - rest
 - rest_command
 - samsungtv
 - scrape
 - statistics
 - systemmonitor
 - shell_command
 - telnet
 - time_data
 - tod
 - tuya
 - wake_on_lan
 - uptime
 - workday
 - version
 - yandex_transport

## Installing and work the following custom components:
 - https://github.com/AlexxIT/XiaomiGateway3
 - https://github.com/AlexxIT/SonoffLAN
 - https://github.com/AlexxIT/YandexStation
 - https://github.com/custom-components/ble_monitor (need rebuild python3-light with Bluetooth support)
 - https://github.com/Limych/ha-gismeteo
 - https://github.com/ArtistAOP/localtuya
 - https://github.com/AlexxIT/Dataplicity       
 - https://github.com/RobHofmann/HomeAssistant-GreeClimateComponent


After script prints `Done.` you have Home Assistant installed. 
Start the service or reboot the device to get it start automatically.
The web interface will be on 8123 port after all components load.

![Home Assitant](homeassistant.png)

The only components with flows included are MQTT and ZHA.
After adding a component in the interface or via the config
HA could install dependencies and fails on finding them after installation.
In this case restarting HA could work.

Other components are not tested and may require additional changed in 
requirement versions or python libraries.

## ZHA usage on Xiaomi Gateway

The component uses internal UART to communicate with ZigBee chip.
The chip has to be flashed with a proper firmware to be able to 
communicate with the HA. The recommended firmware is 

```
wget https://github.com/openlumi/ZiGate/releases/download/snapshot-20201201/ZigbeeNodeControlBridge_JN5169_FULL_FUNC_DEVICE_31e_115200.bin -O /tmp/zigate.bin 
jnflash /tmp/zigate.bin
jntool erase_pdm
jntool soft_reset
```

You could try another Zigate firmwares for JN5169 chip. The baud rate
must be 115200 as it is hardcoded in zigpy-zigate.

## Enabling other components and installing custom


You may want to add more components to your HA installation.
In this case you have to copy the directory with component to 
`/usr/lib/python3.9/site-packages/homeassistant-2021.5.5-py3.9.egg/homeassistant/components/`
or create `custom_components` directory in `/etc/homeassistant` and
copy it there.

Try to install requirements from `manifest.json` with `pip3` manually
to check it installs and doesn't require pre-compiled C libraries.
Otherwise, you have to cross-compile python3 dependencies and install
them as `ipk` packages.

