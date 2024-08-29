FROM amneziavpn/amneziawg-go:0.2.12

RUN addgroup -g 1000 awg && \
  adduser -u 1000 -G awg -h /home/awg -D awg && \
  echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel && \
  adduser awg wheel && \
  install -o 1000 -g 1000 -d -m 0700 /etc/amneziawg && \
  ln -s /usr/bin/awg /usr/bin/wg && \
  ln -s /usr/bin/awg-quick /usr/bin/wg-quick && \
  ln -s /etc/amneziawg /etc/wireguard

USER awg
WORKDIR /home/awg
COPY ./entrypoint.sh ./entrypoint.sh
CMD ["/bin/sh", "-c", "/home/awg/entrypoint.sh"]
