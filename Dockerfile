FROM golang:1.23.0-alpine

RUN apk add --no-cache fio==3.36-r0

COPY fio_jobs /jobs
COPY mount_configs /configs

VOLUME /data
WORKDIR /data

COPY entrypoint.sh /data/entrypoint.sh

RUN chmod +x /data/entrypoint.sh

ENTRYPOINT [ "sh", "/data/entrypoint.sh" ]
