# Inspired by https://github.com/google/cadvisor/issues/1236#issuecomment-578093121
FROM golang:1.13-buster AS builder
ARG VERSION=v0.38.6

RUN apt-get update \
 && apt-get install make git bash gcc \
 && mkdir -p $GOPATH/src/github.com/google \
 && git clone https://github.com/google/cadvisor.git $GOPATH/src/github.com/google/cadvisor

WORKDIR $GOPATH/src/github.com/google/cadvisor
RUN git fetch --tags \
 && git checkout $VERSION \
 && make build \
 && cp ./cadvisor /

FROM alpine:3.10

RUN apk --no-cache add libc6-compat device-mapper findutils && \
    apk --no-cache add thin-provisioning-tools --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf /var/cache/apk/*

COPY --from=builder /cadvisor /usr/bin/cadvisor

EXPOSE 8080

ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]