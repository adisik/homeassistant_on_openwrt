#!/bin/sh
# Homeassistant installer script by @devbis  mod adisik
# wget https://raw.githubusercontent.com/adisik/homeassistant_on_openwrt/main/ha_install_21_02.sh -O - | sh

set -e

PYTHON_VERSION="3.9"
HOMEASSISTANT_VERSION="2021.5.5"
HOMEASSISTANT_FRONTEND_VERSION="20210504.0"

echo "Install base requirements from feed..."
opkg update

# Install them first to check Openlumi feed id added
opkg install \
  python3-base \
  python3-pynacl \
  python3-ciso8601

opkg install \
  patch \
  python3-aiohttp \
  python3-aiohttp-cors \
  python3-async-timeout \
  python3-asyncio \
  python3-attrs \
  python3-bcrypt \
  python3-boto3 \
  python3-botocore \
  python3-certifi \
  python3-cffi \
  python3-cgi \
  python3-cgitb \
  python3-chardet \
  python3-codecs \
  python3-cryptodome \
  python3-cryptography \
  python3-ctypes \
  python3-dateutil \
  python3-dbm \
  python3-decimal \
  python3-defusedxml \
  python3-distutils \
  python3-docutils \
  python3-email \
  python3-gdbm \
  python3-idna \
  python3-jinja2 \
  python3-jmespath \
  python3-light \
  python3-logging \
  python3-lzma \
  python3-markupsafe \
  python3-multidict \
  python3-multiprocessing \
  python3-ncurses \
  python3-netifaces \
  python3-openssl \
  python3-pip \
  python3-pkg-resources \
  python3-ply \
  python3-pycparser \
  python3-pydoc \
  python3-pyopenssl \
  python3-psutil \
  python3-pytz \
  python3-requests \
  python3-s3transfer \
  python3-setuptools \
  python3-six \
  python3-slugify \
  python3-sqlalchemy \
  python3-sqlite3 \
  python3-unittest \
  python3-urllib \
  python3-urllib3 \
  python3-tornado \
  python3-xml \
  python3-yaml \
  python3-yarl \
  python3-zeroconf \
  python3-pillow \
  python3-qrcode \
  python3-cryptodomex
  
# opkg install python3-bluepy

cd /tmp/

echo "Install _distutils_hack..."

# add missing _distutils_hack from setuptools
mkdir -p /usr/lib/python${PYTHON_VERSION}/site-packages/_distutils_hack
wget https://raw.githubusercontent.com/pypa/setuptools/v56.0.0/_distutils_hack/__init__.py -O /usr/lib/python${PYTHON_VERSION}/site-packages/_distutils_hack/__init__.py
wget https://raw.githubusercontent.com/pypa/setuptools/v56.0.0/_distutils_hack/override.py -O /usr/lib/python${PYTHON_VERSION}/site-packages/_distutils_hack/override.py

echo "Install base requirements from PyPI..."
pip3 install wheel
cat << "EOF" > /tmp/requirements.txt
awesomeversion==21.5.0
acme==1.8.0
appdirs==1.4.4
astral==2.2
atomicwrites==1.4.0
distlib==0.3.1
filelock==3.0.12
PyJWT==1.7.1
python-slugify==5.0.0
slugify==0.0.1
text-unidecode==1.3
voluptuous==0.12.1
voluptuous-serialize==2.4.0
importlib-metadata==4.0.1
snitun==0.21.0

# homeassistant manifest requirements
async-upnp-client==0.16.2

PyQRCode==1.2.1
pyMetno==0.8.3
mutagen==1.45.1
pyotp==2.3.0
# exist new version
gTTS==2.2.2
pyroute2==0.5.18

#esphome
aioesphomeapi==2.6.6

construct==2.10.67
samsungtvws==1.4.0

# telegram
python-telegram-bot==13.1
PySocks==1.7.1
decorator==4.4.2 
tornado==6.1
tzlocal==2.1 
APScheduler==3.6.3

# ping
icmplib==2.0

# asuswrt
aioasuswrt==1.3.1

#wakeomlan
wakeonlan==2.0.1

# workday
holidays==0.10.4
pymeeus==0.5.11

#ssdp
async-upnp-client==0.16.2

# xiaomi_gateway3
paho-mqtt==1.5.1

# coronavirus
# coronavirus==1.1.1

# version
pyhaversion==21.5.0
pytest-runner==5.3.0
semantic-version==2.8.5

# rest
jsonpath==0.82
xmltodict==0.12.0
httpx==0.16.1
httpcore==0.12.3
sniffio==1.2.0
h11==0.12.0
rfc3986==1.4.0

# samsungtv
websocket-client==1.0.1
samsungctl==0.7.1
samsungtvws==1.6.0

# tuya
tuyaha==0.0.9

# mobile_app
emoji==1.2.0

# bluetooth
nose==1.3.7
# coverage==3.7.1
pygatt[GATTTOOL]==4.0.5
mitemp_bt==0.0.3
# btlewrap==0.0.8
typing==3.7.4.3

#yandex_transport
aioymaps==1.1.0

#esphome
protobuf==3.17.1
aioesphomeapi==2.6.6

#scrape
beautifulsoup4==4.9.3

#homekit_controller
aiohomekit==0.2.61

# other
netdisco==2.8.2

# zha requirements
pyserial==3.5
zha-quirks==0.0.57
zigpy==0.33.0
zigpy-zigate==0.7.4

# fixed dependencies
python-jose[cryptography]==3.2.0  # 3.3.0 is not compatible with the python3-cryptography in the feed
EOF

pip3 install -r /tmp/requirements.txt

# show internal serial ports for Xiaomi Gateway
sed -i 's/ttyXRUSB\*/ttymxc[1-9]/' /usr/lib/python${PYTHON_VERSION}/site-packages/serial/tools/list_ports_linux.py
sed -i 's/if info.subsystem != "platform"]/]/' /usr/lib/python${PYTHON_VERSION}/site-packages/serial/tools/list_ports_linux.py

# fix deps
sed -i 's/urllib3<1.25,>=1.20/urllib3>=1.20/' /usr/lib/python${PYTHON_VERSION}/site-packages/botocore-*.egg-info/requires.txt
sed -i 's/botocore<1.13.0,>=1.12.135/botocore<1.13.0,>=1.12.0/' /usr/lib/python${PYTHON_VERSION}/site-packages/boto3-*.egg-info/requires.txt

echo "Download files"

wget https://github.com/pvizeli/pycognito/archive/0.1.4.tar.gz -O - > pycognito-0.1.4.tgz
wget https://github.com/ctalkington/python-ipp/archive/0.11.0.tar.gz -O - > python-ipp-0.11.0.tgz
wget https://pypi.python.org/packages/source/p/python-miio/python-miio-0.5.6.tar.gz -O - > python-miio-0.5.6.tar.gz

echo "Installing pycognito..."

tar -zxf pycognito-0.1.4.tgz
cd pycognito-0.1.4
sed -i 's/boto3>=[0-9\.]*/boto3/' setup.py
python3 setup.py install
cd ..                                                                             
rm -rf pycognito-0.1.4 pycognito-0.1.4.tgz

echo "Installing python-ipp..."
tar -zxf python-ipp-0.11.0.tgz
cd python-ipp-0.11.0
sed -i 's/aiohttp>=[0-9\.]*/aiohttp/' requirements.txt
sed -i 's/yarl>=[0-9\.]*/yarl/' requirements.txt
python3 setup.py install
cd ..
rm -rf python-ipp-0.11.0 python-ipp-0.11.0.tgz

echo "Installing python-miio..."
tar -zxf python-miio-0.5.6.tar.gz
cd python-miio-0.5.6
sed -i 's/cryptography>=3,<4/cryptography>=2,<4/' setup.py
find . -type f -exec touch {} +
python3 setup.py install
cd ..
rm -rf python-miio-0.5.6 python-miio-0.5.6.tar.gz
pip3 install PyXiaomiGateway==0.13.4

echo "Install hass_nabucasa and ha-frontend..."
wget https://github.com/NabuCasa/hass-nabucasa/archive/0.43.0.tar.gz -O - > hass-nabucasa-0.43.0.tar.gz
tar -zxf hass-nabucasa-0.43.0.tar.gz
cd hass-nabucasa-0.43.0
sed -i 's/==.*"/"/' setup.py
sed -i 's/>=.*"/"/' setup.py
python3 setup.py install
cd ..
rm -rf hass-nabucasa-0.43.0.tar.gz hass-nabucasa-0.43.0

# tmp might be small for frontend
cd /root
rm -rf home-assistant-frontend.tar.gz
rm -rf home-assistant-frontend-${HOMEASSISTANT_FRONTEND_VERSION}

wget https://pypi.python.org/packages/source/h/home-assistant-frontend/home-assistant-frontend-${HOMEASSISTANT_FRONTEND_VERSION}.tar.gz -O home-assistant-frontend.tar.gz
tar -zxf home-assistant-frontend.tar.gz
cd home-assistant-frontend-${HOMEASSISTANT_FRONTEND_VERSION}
find ./hass_frontend/frontend_es5 -name '*.js' -exec rm -rf {} \;
find ./hass_frontend/frontend_es5 -name '*.map' -exec rm -rf {} \;
find ./hass_frontend/frontend_es5 -name '*.txt' -exec rm -rf {} \;
find ./hass_frontend/frontend_latest -name '*.js' -exec rm -rf {} \;
find ./hass_frontend/frontend_latest -name '*.map' -exec rm -rf {} \;
find ./hass_frontend/frontend_latest -name '*.txt' -exec rm -rf {} \;

find ./hass_frontend/static/mdi -name '*.json' -maxdepth 1 -exec rm -rf {} \;
find ./hass_frontend/static/polyfills -name '*.js' -maxdepth 1 -exec rm -rf {} \;
find ./hass_frontend/static/polyfills -name '*.map' -maxdepth 1 -exec rm -rf {} \;

# shopping list and calendar missing gzipped
# gzip ./hass_frontend/static/translations/calendar/*
gzip ./hass_frontend/static/translations/shopping_list/*

find ./hass_frontend/static/translations -name '*.json' -exec rm -rf {} \;

# rm -rf /usr/lib/python3.9/site-packages/hass_frontend
mv hass_frontend /usr/lib/python${PYTHON_VERSION}/site-packages/hass_frontend

# find /root/home-assistant-frontend-20210504.0/ -type f -exec touch -t 201601011200 '{}' \;

python3 setup.py install
cd ..
rm -rf home-assistant-frontend.tar.gz home-assistant-frontend-${HOMEASSISTANT_FRONTEND_VERSION}
cd /tmp

rm -rf homeassistant.tar.gz
rm -rf homeassistant-${HOMEASSISTANT_VERSION}

echo "Install HASS"
wget https://pypi.python.org/packages/source/h/homeassistant/homeassistant-${HOMEASSISTANT_VERSION}.tar.gz -O homeassistant.tar.gz
tar -zxf homeassistant.tar.gz
rm -rf homeassistant.tar.gz
cd homeassistant-${HOMEASSISTANT_VERSION}/homeassistant/
echo '' > requirements.txt

mv -f components components-orig
mkdir components
cd components-orig
mv -f \
  __init__.py \
  alarm_control_panel \
  analytics \
  alert \
  alexa \
  asuswrt \
  api \
  auth \
  automation \
  binary_sensor \
  bluetooth_le_tracker \
  camera \
  climate \
  cloud \
  command_line \
  config \
  coronavirus \
  cover \
  default_config \
  device_automation \
  device_tracker \
  dhcp \
  esphome \
  fan \
  file\
  filter \
  frontend \
  generic \
  google_assistant \
  google_translate \
  group \
  hassio \
  homekit_controller \
  history \
  trace \
  homeassistant \
  http \
  humidifier \
  image_processing \
  input_boolean \
  input_datetime \
  input_number \
  input_select \
  input_text \
  ipp \
  light \
  lock \
  local_ip \
  logger \
  logbook \
  lovelace \
  map \
  media_player \
  met \
  my \
  moon \
  min_max \
  mobile_app \
  notify \
  number \
  onboarding \
  persistent_notification \
  panel_iframe \
  person \
  ping \
  recorder \
  remote \
  rest \
  rest_command \
  samsungtv \
  scene \
  script \
  scrape \
  search \
  sensor \
  shopping_list \
  ssdp \
  stream \
  sun \
  switch \
  statistics \
  safe_mode \
  system_health \
  system_log \
  systemmonitor \
  shell_command \
  timer \
  telnet \
  telegram \
  telegram_bot \
  template \
  time_date \
  tod \
  tts \
  tuya \
  updater \
  vacuum \
  weather \
  webhook \
  wake_on_lan\
  websocket_api \
  xiaomi_aqara \
  xiaomi_miio \
  zeroconf \
  zha \
  zone \
  blueprint \
  counter \
  image \
  media_source \
  tag \
  panel_custom \
  brother \
  discovery \
  mqtt \
  upnp \
  uptime \
  workday \
  version \
  yandex_transport \
  mpd \
  ../components
cd ..
rm -rf components-orig
cd components

# serve static with gzipped files
sed -i 's/filepath = self._directory.joinpath(filename).resolve()/try:\n                filepath = self._directory.joinpath(Path(rel_url + ".gz")).resolve()\n                if not filepath.exists():\n                    raise FileNotFoundError()\n            except Exception as e:\n                filepath = self._directory.joinpath(filename).resolve()/' http/static.py

sed -i 's/sqlalchemy==[0-9\.]*/sqlalchemy/' recorder/manifest.json
sed -i 's/pillow==[0-9\.]*/pillow/' image/manifest.json
sed -i 's/, UnidentifiedImageError//' image/__init__.py
sed -i 's/except UnidentifiedImageError/except OSError/' image/__init__.py
sed -i 's/zeroconf==[0-9\.]*/zeroconf/' zeroconf/manifest.json
sed -i 's/netdisco==[0-9\.]*/netdisco/' discovery/manifest.json
sed -i 's/PyNaCl==[0-9\.]*/PyNaCl/' mobile_app/manifest.json
sed -i 's/"defusedxml==[0-9\.]*", "netdisco==[0-9\.]*"/"defusedxml", "netdisco"/' ssdp/manifest.json
# remove unwanted zha requirements
sed -i 's/"bellows==[0-9\.]*",//' zha/manifest.json
sed -i 's/"zigpy-cc==[0-9\.]*",//' zha/manifest.json
sed -i 's/"zigpy-deconz==[0-9\.]*",//' zha/manifest.json
sed -i 's/"zigpy-xbee==[0-9\.]*",//' zha/manifest.json
sed -i 's/"zigpy-znp==[0-9\.]*"//' zha/manifest.json
sed -i 's/"zigpy-zigate==[0-9\.]*",/"zigpy-zigate"/' zha/manifest.json
sed -i 's/import bellows.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_cc.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_deconz.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_xbee.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_znp.zigbee.application//' zha/core/const.py
sed -i -e '/znp = (/,/)/d' -e '/ezsp = (/,/)/d' -e '/deconz = (/,/)/d' -e '/ti_cc = (/,/)/d' -e '/xbee = (/,/)/d' zha/core/const.py

sed -i 's/"cloud",//' default_config/manifest.json
sed -i 's/"dhcp",//' default_config/manifest.json
sed -i 's/"mobile_app",//' default_config/manifest.json
sed -i 's/"updater",//' default_config/manifest.json

cd ../..
sed -i 's/    "/    # "/' homeassistant/generated/config_flows.py
sed -i 's/    # "asuswrt"/    "asuswrt"/' homeassistant/generated/config_flows.py
sed -i 's/    # "local_ip"/    "local_ip"/' homeassistant/generated/config_flows.py
sed -i 's/    # "mobile_app"/    "mobile_app"/' homeassistant/generated/config_flows.py
sed -i 's/    # "mqtt"/    "mqtt"/' homeassistant/generated/config_flows.py
sed -i 's/    # "zha"/    "zha"/' homeassistant/generated/config_flows.py
sed -i 's/    # "upnp"/    "upnp"/' homeassistant/generated/config_flows.py
sed -i 's/    # "tuya"/    "tuya"/' homeassistant/generated/config_flows.py
sed -i 's/    # "samsungtv"/    "samsungtv"/' homeassistant/generated/config_flows.py
sed -i 's/    # "homekit_controller"/    "homekit_controller"/' homeassistant/generated/config_flows.py
sed -i 's/    # "esphome"/    "esphome"/' homeassistant/generated/config_flows.py

sed -i 's/"installation_type": "Unknown"/"installation_type": "Home Assistant on OpenWrt"/' homeassistant/helpers/system_info.py
sed -i 's/install_requires=REQUIRES/install_requires=[]/' setup.py

sed -i 's/session.get_transaction()/session.transaction/' homeassistant/components/recorder/util.py

# Change file timestamp
#find /tmp/homeassistant-${HOMEASSISTANT_VERSION}/ -type f -exec touch -t 201601011200 '{}' \;
find . -type f -exec touch {} +

python3 setup.py install
cd ../
rm -rf homeassistant-${HOMEASSISTANT_VERSION}/

mkdir -p /etc/homeassistant
ln -s /etc/homeassistant /root/.homeassistant
cat << "EOF" > /etc/homeassistant/configuration.yaml
# Configure a default setup of Home Assistant (frontend, api, etc)
default_config:

# Text to speech
tts:
  - platform: google_translate
    language: ru

recorder:
  purge_keep_days: 1
  db_url: 'sqlite:///:memory:'

group: !include groups.yaml
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
EOF

touch /etc/homeassistant/groups.yaml
touch /etc/homeassistant/automations.yaml
touch /etc/homeassistant/scripts.yaml
touch /etc/homeassistant/scenes.yaml

echo "Create starting script in init.d"
cat << "EOF" > /etc/init.d/homeassistant
#!/bin/sh /etc/rc.common

START=99
USE_PROCD=1

start_service()
{
    procd_open_instance
    procd_set_param command hass --config /etc/homeassistant
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF
chmod +x /etc/init.d/homeassistant
/etc/init.d/homeassistant enable
/etc/init.d/homeassistant start

# pip3 uninstall JWT
echo "Done."

# Замена в файле components\recorder\util.py  if session.get_transaction(): на         if session.transaction:
