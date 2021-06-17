FROM nginx:stable-alpine

ENV PROXY_UPSTREAM_INFLUXDB_HOST: influxdb
ENV PROXY_UPSTREAM_INFLUXDB_PORT: 8086
ENV PROXY_UPSTREAM_GRAFANA_HOST=grafana
ENV PROXY_UPSTREAM_GRAFANA_PORT=3000

COPY nginx/nginx.conf.tpl /etc/nginx/nginx.conf.tpl
# COPY nginx/nginx.crt /etc/nginx/nginx.crt
# COPY nginx/nginx.key /etc/nginx/nginx.key

COPY nginx/main.sh /main.sh
RUN chmod +x /main.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["sh","/main.sh"]
