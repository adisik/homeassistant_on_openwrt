#!/bin/sh
# Homeassistant installer script by @devbis

set -e

echo "Install base requirements from feed..."
opkg update

# Install them first to check Openlumi feed id added
opkg install \
  python3-base \
  python3-pynacl \
  python3-ciso8601

opkg install \
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
  python3-pytz \
  python3-requests \
  python3-s3transfer \
  python3-setuptools \
  python3-six \
  python3-sqlalchemy \
  python3-sqlite3 \
  python3-unittest \
  python3-urllib \
  python3-urllib3 \
  python3-xml \
  python3-yaml \
  python3-yarl \
  python3-netdisco \
  python3-paho-mqtt \
  python3-zeroconf \
  python3-pillow \
  python3-bluepy \
  python3-cryptodomex
  

cd /tmp/


echo "Install base requirements from PyPI..."
pip3 install wheel
cat << "EOF" > /tmp/requirements.txt
awesomeversion==21.5.0
acme==1.8.0
appdirs==1.4.4
astral==1.10.1
atomicwrites==1.4.0
# attr==0.3.1
distlib==0.3.1
filelock==3.0.12
PyJWT==1.7.1
jwt==1.2.0
# python-slugify==5.0.0
# slugify==0.0.1
text-unidecode==1.3
voluptuous==0.12.1
voluptuous-serialize==2.4.0
importlib-metadata
snitun==0.20

# homeassistant manifest requirements
# PyQRCode==1.2.1
# pyMetno==0.8.3
mutagen==1.45.1
pyotp==2.3.0
gTTS==2.2.1

# telegram
python-telegram-bot==13.1
PySocks==1.7.1
decorator==4.4.2 
# tornado==6.1
tzlocal==2.1 
APScheduler==3.6.3

# ping
icmplib==2.0

# asuswrt
aioasuswrt==1.3.1

# workday
# holidays==0.10.4
# pymeeus==0.4.0

# ssdp    async-upnp-client==0.16.2
async-upnp-client==0.14.13

# xiaomi_gateway3      
# paho-mqtt==1.5.0

# coronavirus
# coronavirus==1.1.1

# version
pyhaversion==3.4.2
pytest-runner==5.3.0
semantic-version==2.8.5

# rest
# jsonpath==0.82
xmltodict==0.12.0
httpx==0.16.1
httpcore==0.12.3
sniffio==1.2.0
h11==0.12.0
rfc3986==1.4.0

# samsungtv
websocket-client==0.56.0
samsungctl[websocket]==0.7.1
samsungtvws==1.4.0

# tuya
tuyaha==0.0.9

# mobile_app
emoji==0.5.4

# bluetooth
nose==1.3.7
coverage==3.7.1
pygatt[GATTTOOL]==4.0.5
mitemp_bt==0.0.3
btlewrap==0.0.8
typing==3.7.4.3

#yandex_transport
aioymaps==1.1.0

#esphome
aioesphomeapi==2.6.3
protobuf==3.15.8

#scrape
beautifulsoup4==4.9.1

# zha requirements
pyserial==3.5
zha-quirks==0.0.51
zigpy==0.30.0
zigpy-zigate==0.7.3
EOF

pip3 install -r /tmp/requirements.txt

# show internal serial ports for Xiaomi
sed -i 's/ttyXRUSB\*/ttymxc[1-9]/' /usr/lib/python3.7/site-packages/serial/tools/list_ports_linux.py
sed -i 's/if info.subsystem != "platform"]/]/' /usr/lib/python3.7/site-packages/serial/tools/list_ports_linux.py

# fix deps
sed -i 's/urllib3<1.25,>=1.20/urllib3<1.26,>=1.20/' /usr/lib/python3.9/site-packages/botocore-1.12.66-py3.9.egg-info/requires.txt
sed -i 's/botocore<1.13.0,>=1.12.135/botocore<1.13.0,>=1.12.66/' /usr/lib/python3.9/site-packages/boto3-1.9.135-py3.9.egg-info/requires.txt

echo "Download files"

wget https://github.com/pvizeli/pycognito/archive/0.1.4.tar.gz -O - > pycognito-0.1.4.tgz
wget https://github.com/ctalkington/python-ipp/archive/0.11.0.tar.gz -O - > python-ipp-0.11.0.tgz
wget https://files.pythonhosted.org/packages/b8/ad/31d10dbad025a8411029c5041129de14f9bb9f66a990de21be0011e19041/python-miio-0.5.4.tar.gz -O - > python-miio-0.5.4.tar.gz
echo "Installing pycognito..."

tar -zxf pycognito-0.1.4.tgz
cd pycognito-0.1.4
sed -i 's/boto3>=1.10.49/boto3>=1.9.135/' setup.py
python3 setup.py install
cd ..
rm -rf pycognito-0.1.4 pycognito-0.1.4.tgz

echo "Installing python-ipp..."
tar -zxf python-ipp-0.11.0.tgz
cd python-ipp-0.11.0
sed -i 's/aiohttp>=3.6.2/aiohttp>=3.5.4/' requirements.txt
sed -i 's/yarl>=1.4.2/yarl>=1.3.0/' requirements.txt
python3 setup.py install
cd ..
rm -rf python-ipp-0.11.0 python-ipp-0.11.0.tgz


echo "Installing python-miio..."
tar -zxf python-miio-0.5.4.tar.gz
cd python-miio-0.5.4
sed -i 's/cryptography>=3,<4/cryptography>=2,<4/' setup.py
find . -type f -exec touch {} +
python3 setup.py install
cd ..
rm -rf python-miio-0.5.4 python-miio-0.5.4.tar.gz
pip3 install PyXiaomiGateway==0.13.4

echo "Install hass_nabucasa and ha-frontend..."
wget https://github.com/NabuCasa/hass-nabucasa/archive/0.43.1.tar.gz -O - > hass-nabucasa-0.43.1.tar.gz
tar -zxf hass-nabucasa-0.43.1.tar.gz
cd hass-nabucasa-0.43.1
sed -i 's/==.*"/"/' setup.py
sed -i 's/>=.*"/"/' setup.py
python3 setup.py install
cd ..
rm -rf hass-nabucasa-0.43.1.tar.gz hass-nabucasa-0.43.1

# tmp might be small for frontend
cd /root
rm -rf home-assistant-frontend-20210518.0.tar.gz
rm -rf home-assistant-frontend-20210518.0

# wget https://files.pythonhosted.org/packages/9c/49/7c0e3890da95fbf3c287a6f0568fcbec9112e5c4264910e712e4fd2622d1/home-assistant-frontend-20210518.0.tar.gz -O home-assistant-frontend-20210518.0.tar.gz
wget https://files.pythonhosted.org/packages/5d/04/35f06c52b6d00dc104479d0fa7e425f790c5612bfc407cd2edf85d1ce4ae/home-assistant-frontend-20210504.0.tar.gz -O home-assistant-frontend-20210504.0.tar.gz

tar -zxf home-assistant-frontend-20210504.0.tar.gz
cd home-assistant-frontend-20210504.0
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
gzip ./hass_frontend/static/translations/calendar/*
gzip ./hass_frontend/static/translations/shopping_list/*

find ./hass_frontend/static/translations -name '*.json' -exec rm -rf {} \;

rm -rf /usr/lib/python3.9/site-packages/hass_frontend
mv -f hass_frontend /usr/lib/python3.9/site-packages/hass_frontend

find /root/home-assistant-frontend-20210504.0/ -type f -exec touch -t 201601011200 '{}' \;

python3 setup.py install
cd ..
rm -rf home-assistant-frontend-20210504.0.tar.gz home-assistant-frontend-20210504.0
cd /tmp

rm -rf homeassistant-2021.5.5.tar.gz
rm -rf homeassistant-2021.5.5

echo "Install HASS"
wget https://files.pythonhosted.org/packages/21/d1/431197d2a6f74807cd7f69caa91e11d619cb47a1fde687abfdd812a4c4b1/homeassistant-2021.5.5.tar.gz -O - > /tmp/homeassistant-2021.5.5.tar.gz
tar -zxf homeassistant-2021.5.5.tar.gz
rm -rf homeassistant-2021.5.5.tar.gz
cd homeassistant-2021.5.5/homeassistant/
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
  system_health \
  system_log \
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

sed -i 's/sqlalchemy==1.3.23/sqlalchemy/' recorder/manifest.json
sed -i 's/pillow==8.1.0/pillow/' image/manifest.json
sed -i 's/, UnidentifiedImageError//' image/__init__.py
sed -i 's/except UnidentifiedImageError/except OSError/' image/__init__.py
sed -i 's/zeroconf==0.28.8/zeroconf/' zeroconf/manifest.json
sed -i 's/netdisco==2.8.2/netdisco/' discovery/manifest.json
sed -i 's/PyNaCl==1.3.0/PyNaCl/' mobile_app/manifest.json
sed -i 's/"defusedxml==0.6.0", "netdisco==2.8.2"/"defusedxml", "netdisco"/' ssdp/manifest.json
# remove unwanted zha requirements
sed -i 's/"bellows==0.21.0",//' zha/manifest.json
sed -i 's/"zigpy-cc==0.5.2",//' zha/manifest.json
sed -i 's/"zigpy-deconz==0.11.1",//' zha/manifest.json
sed -i 's/"zigpy-xbee==0.13.0",//' zha/manifest.json
sed -i 's/"zigpy-znp==0.3.0"//' zha/manifest.json
sed -i 's/"zigpy-zigate==0.7.3",/"zigpy-zigate"/' zha/manifest.json
sed -i 's/import bellows.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_cc.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_deconz.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_xbee.zigbee.application//' zha/core/const.py
sed -i 's/import zigpy_znp.zigbee.application//' zha/core/const.py
sed -i -e '/znp = (/,/)/d' -e '/ezsp = (/,/)/d' -e '/deconz = (/,/)/d' -e '/ti_cc = (/,/)/d' -e '/xbee = (/,/)/d' zha/core/const.py

sed -i 's/"cloud",//' default_config/manifest.json
sed -i 's/"mobile_app",//' default_config/manifest.json
sed -i 's/"updater",//' default_config/manifest.json

cd ../..
sed -i 's/    "/    # "/' homeassistant/generated/config_flows.py
sed -i 's/    # "mqtt"/    "mqtt"/' homeassistant/generated/config_flows.py
sed -i 's/    # "zha"/    "zha"/' homeassistant/generated/config_flows.py

sed -i 's/install_requires=REQUIRES/install_requires=[]/' setup.py

find /tmp/homeassistant-2021.5.5/ -type f -exec touch -t 201601011200 '{}' \;

python3 setup.py install
cd ../
rm -rf homeassistant-2021.5.5/

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
  purge_keep_days: 3
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

echo "Done."

# ������ � ����� components\recorder\util.py  if session.get_transaction(): ��         if session.transaction:
