#!/bin/sh

stop () {
    awg-quick down wg0
    exit 0
}
trap stop SIGTERM SIGINT SIGQUIT

# kill daemons in case of restart
wg-quick down /etc/wireguard/wg0.conf

# start daemons if configured
if [ -f /etc/wireguard/wg0.conf ]; then (wg-quick up /etc/wireguard/wg0.conf); fi

echo "Public key '$(sudo cat /etc/wireguard/wg0.conf | sed -n 's/^PrivateKey = //p' | wg pubkey)'"
sleep infinity &
wait $!
