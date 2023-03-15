#!/bin/sh
set -e
set -x

if [ $(grep -ci $CUPSADMIN /etc/shadow) -eq 0 ]; then
    useradd -r -G sudo,lp,lpadmin -M $CUPSADMIN && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers 
fi
echo $CUPSADMIN:$CUPSPASSWORD | chpasswd

#mkdir -p /config/ppd
#mkdir -p /services
#rm -rf /etc/cups/ppd

if [ ! -f /etc/cups/cupsd.conf ]; then
    cp -R /etc/cups_default/* /etc/cups/
    mkdir -p /etc/cups/ppd
    mkdir -p /etc/cups/interfaces
#    rm -Rf /etc/cups
#    ln -s /config /etc/cups 
fi
#if [ ! -f /etc/cups/printers.conf ]; then
#    touch /etc/cups/printers.conf
#fi


#dbus-daemon --system &
#sleep 1
#avahi-daemon --daemonize &

#/root/printer-update.sh &
exec /usr/sbin/cupsd -f
