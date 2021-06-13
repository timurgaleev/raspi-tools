
# Raspberry Pi Monitoring with Prometheus, Grafana & Cadvisor

### Create nginx certificates

You need to create self signed certificate in order to use HTTPS with you exposed proxy. You can use any guide, e.g. the one from [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04).

The `.crt.` and `.key` files should reside in `./proxy/`.

### Run

`docker-compose up -d`

## Accessing the proxy

The proxy is exposed only to the localhost, thus we can reach it via ssh tunel from our machine:

```
ssh -N -L 443:127.0.0.1:443 -i <location_of_your_ssh_key> <user@<ip>
```

e.g.:
```
ssh -N -L 443:127.0.0.1:443 -i ~/.ssh/id_rsa pi@192.168.1.20
```

Having the tunnel running, you can visit the proxy:

```
https://127.0.0.1/grafana
https://127.0.0.1/prometheus/graph
https://127.0.0.1/cadvisor/containers/
https://127.0.0.1/node-exporter/metrics
```

## Post Setup

When setting up a Grafana Data Source, use docker provided DNS resolution of a custom bridge networking (`http://prometheus:9090`).
