
# edit/uncomment to set the timezone if desired
ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# install weewx prerequisites
pkg install -y python3
pkg install -y py38-pip
pkg install -y py38-configobj
pkg install -y py38-pillow
pkg install -y py38-pyserial
pkg install -y py38-pyusb
pkg install -y py38-cheetah3
pkg install -y py38-sqlite3
pkg install -y py38-mysqlclient
# pkg install py38-ephem

# not really necessary but helpful perhaps
ln -s /usr/local/bin/python3 /usr/local/bin/python

# download and install weewx in Simulator mode
fetch https://weewx.com/downloads/weewx-4.5.1.tar.gz
tar xvfz weewx-4.5.1.tar.gz
cd weewx-4.5.1
/usr/local/bin/python3 ./setup.py build
/usr/local/bin/python3 ./setup.py install --no-prompt

# supersede the startup file defaults with typical setup.py paths to things
# then put the startupfile into place
echo 'WEEWX_BIN="/home/weewx/bin/weewxd"'  > /etc/defaults/weewx
echo 'WEEWX_CFG="/home/weewx/weewx.conf"' >> /etc/defaults/weewx
echo 'WEEWX_PID="/var/run/weewx.pid"'     >> /etc/defaults/weewx
cp util/init.d/weewx.bsd /etc/rc.d/weewx
chmod 555 /etc/rc.d/weewx

# turn debug on and set htmlroot to match freebsd's odd nginx expectations
cd /home/weewx
cp weewx.conf weewx.conf.keepme
cat weewx.conf.keepme | sed -e s:debug\ =\ 0:debug\ =\ 1: -e s:public_html:/usr/local/www/nginx: > weewx.conf

# enable and start weewx manually
#  - the 'enable' does not seem to work for subsequent reboots
echo 'weewx_enable="YES"' >> /etc/rc.conf
service weewx start

# install, enable, and start nginx
pkg install -y nginx
echo 'nginx_enable="YES"' >> /etc/rc.conf
service nginx start

