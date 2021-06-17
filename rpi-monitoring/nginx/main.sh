#!/bin/sh

envsubst '${PROXY_UPSTREAM_INFLUXDB_HOST}${PROXY_UPSTREAM_INFLUXDB_PORT}${PROXY_UPSTREAM_GRAFANA_HOST}${PROXY_UPSTREAM_GRAFANA_PORT}' < /etc/nginx/nginx.conf.tpl > /etc/nginx/nginx.conf
nginx -g "daemon off;"
