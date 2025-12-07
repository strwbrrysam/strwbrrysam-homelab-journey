install required packages

wget the required file

tar xzvf softether.tar.gz

navigate to the extracted stuff and do make

mv vpnserver to desired install location usually i did /etc/softether

cd to /etc/softether

chmod 600

chmod 700 vpncmd

chmod 700 vpnserver

./vpncmd

inside you wanna select 3 for vpn tools

then type 'check'

it will check the system and stuff for errors and suitability to run softether vpn

register a startup script

and create a systemd unit file

systemctl enable service
systemctl start service
systemctl stop service etc stuff like that

this concludes temporary notes
