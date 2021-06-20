FROM telegraf:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
  mtr \
  speedtest-cli && \
  rm -rf /var/lib/apt/lists/* && \
  usermod -G video telegraf

EXPOSE 8125/udp 8092/udp 8094

CMD ["telegraf"]
