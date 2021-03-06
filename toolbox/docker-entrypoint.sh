#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	/usr/bin/ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	/usr/bin/ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

/etc/init.d/freeradius start >/dev/null 2>/dev/null &
/etc/init.d/tacacs_plus start >/dev/null 2>/dev/null &
/etc/init.d/rsyslog start >/dev/null 2>/dev/null &
/etc/init.d/snmpd start >/dev/null 2>/dev/null &
/etc/init.d/snmptrapd start >/dev/null 2>/dev/null &

exec "$@"
