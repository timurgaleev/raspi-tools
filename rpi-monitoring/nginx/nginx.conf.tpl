worker_processes 1;

events {
  worker_connections 1024;
  use epoll;
}

http {

  upstream nodeexporter_svc {
    least_conn;
    server ${PROXY_UPSTREAM_NODEEXPORTER_HOST}:${PROXY_UPSTREAM_NODEEXPORTER_PORT};
  }

  upstream cadvisor_svc {
    least_conn;
    server ${PROXY_UPSTREAM_CADVISOR_HOST}:${PROXY_UPSTREAM_CADVISOR_PORT};
  }

  upstream prometheus_svc {
    least_conn;
    server ${PROXY_UPSTREAM_PROMETHEUS_HOST}:${PROXY_UPSTREAM_PROMETHEUS_PORT};
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
    location /node-exporter/ {
      proxy_pass http://nodeexporter_svc/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
      proxy_redirect off;
    }

    location /cadvisor/ {
      proxy_pass http://cadvisor_svc/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
      proxy_redirect off;
    }

    location /prometheus/ {
      proxy_pass http://prometheus_svc/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_cache_bypass $http_upgrade;
      proxy_redirect off;
    }

    location /grafana/ {
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
