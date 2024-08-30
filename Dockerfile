FROM amneziavpn/amneziawg-go:0.2.12

RUN apk add --no-cache sudo bash && \
  addgroup -g 1000 awg && \
  adduser -u 1000 -G awg -h /home/awg -D awg && \
  echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel && \
  adduser awg wheel


USER awg
WORKDIR /home/awg
COPY ./entrypoint.sh ./entrypoint.sh
CMD ["/bin/sh", "-c", "/home/awg/entrypoint.sh"]
