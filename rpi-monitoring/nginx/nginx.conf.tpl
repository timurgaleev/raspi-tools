worker_processes 1;

events {
  worker_connections 1024;
  use epoll;
}

http {

  upstream influxdb_svc {
    least_conn;
    server ${PROXY_UPSTREAM_INFLUXDB_HOST}:${PROXY_UPSTREAM_INFLUXDB_PORT};
  }

  upstream grafana_svc {
    least_conn;
    server ${PROXY_UPSTREAM_GRAFANA_HOST}:${PROXY_UPSTREAM_GRAFANA_PORT};
  }

  server {
    listen 80;
  #   return 301 https://$host$request_uri;
  # }

  # server {
  #   listen 443;
  #   ssl on;
  #   ssl_certificate /etc/nginx/nginx.crt;
  #   ssl_certificate_key /etc/nginx/nginx.key;
  #   ssl_protocols TLSv1.2;
    log_subrequest on;

    location /influxdb/ {
      proxy_pass http://influxdb_svc/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
      proxy_redirect off;
    }

    location /grafana/(.*) {
      proxy_pass http://grafana_svc/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
      proxy_redirect off;
    }
  }
}
