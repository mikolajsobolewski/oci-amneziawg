#!/bin/sh

stop () {
    awg-quick down wg0
    exit 0
}
trap stop SIGTERM SIGINT SIGQUIT

wg-quick up /etc/amneziawg/wg0.conf
echo "Public key '$(sudo cat /etc/amneziawg/privatekey | wg pubkey)'"
sleep infinity &
wait $!
