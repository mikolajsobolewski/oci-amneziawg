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

# Optional AmneziaWG header protection (AWG 3): the config parser cannot set it,
# so inject the key into the running device over the UAPI socket after bring-up.
# The key file holds the 32-byte key as 64 hex chars. Opt-in: skipped if absent.
HEADER_PROTECTION_KEY_FILE="${HEADER_PROTECTION_KEY_FILE:-/etc/amneziawg/header-protection.key}"
if [ -f "$HEADER_PROTECTION_KEY_FILE" ]; then
    hpk="$(tr -d ' \t\r\n' < "$HEADER_PROTECTION_KEY_FILE")"
    sock="/var/run/amneziawg/wg0.sock"
    i=0
    while [ ! -S "$sock" ] && [ "$i" -lt 30 ]; do i=$((i + 1)); sleep 1; done
    if [ -S "$sock" ]; then
        resp="$(printf 'set=1\nheader_protection_key=%s\n\n' "$hpk" | sudo socat -t2 - UNIX-CONNECT:"$sock")"
        case "$resp" in
            *errno=0*) echo "AmneziaWG header protection: enabled" ;;
            *) echo "AmneziaWG header protection: FAILED to set (response: ${resp:-none})" >&2 ;;
        esac
    else
        echo "AmneziaWG header protection: UAPI socket $sock not found, key NOT applied" >&2
    fi
fi

echo "Public key '$(sudo cat /etc/wireguard/wg0.conf | sed -n 's/^PrivateKey = //p' | wg pubkey)'"
sleep infinity &
wait $!
