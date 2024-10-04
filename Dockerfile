FROM golang:1.23.0-alpine

RUN apk add --no-cache fio==3.36-r0

COPY fio_jobs /jobs
COPY mount_configs /configs

VOLUME /data
WORKDIR /data

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
