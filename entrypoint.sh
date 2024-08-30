#!/bin/sh

stop () {
    awg-quick down wg0
    exit 0
}
trap stop SIGTERM SIGINT SIGQUIT

if [ ! -c /dev/net/tun ]; then
    sudo mkdir -p /dev/net
    ls -la /dev
    sudo mknod /dev/net/tun c 10 200
    ls -la /dev/net
    sudo chmod 600 /dev/net/tun
fi
wg-quick up /etc/wireguard/wg0.conf
echo "Public key '$(sudo cat /etc/wireguard/privatekey | wg pubkey)'"
sleep infinity &
wait $!
