ARG OS_VERSION
ARG OS_NAME

# Image with gcsfuse installed and its package (.deb)
FROM golang:1.23.0 as gcsfuse-package

RUN apt-get update -qq && apt-get install -y ruby ruby-dev rubygems build-essential rpm fuse && gem install --no-document bundler

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=auto

ARG GCSFUSE_REPO="https://github.com/googlecloudplatform/gcsfuse/"
ARG COMMIT_ID=1ad2eb502a7cfdc07c7920433018ab9461724236
RUN git clone ${GCSFUSE_REPO}

ARG GCSFUSE_PATH=${GOPATH}/gcsfuse
WORKDIR ${GCSFUSE_PATH}

RUN git checkout ${COMMIT_ID}

ARG GCSFUSE_BIN="/gcsfuse"
WORKDIR ${GOPATH}

WORKDIR ${GCSFUSE_PATH}/tools/build_gcsfuse
RUN go install
RUN mkdir -p ${GCSFUSE_BIN}
RUN build_gcsfuse ${GCSFUSE_PATH} ${GCSFUSE_BIN} ${COMMIT_ID}
RUN mkdir -p ${GCSFUSE_BIN}/usr && mv ${GCSFUSE_BIN}/bin ${GCSFUSE_BIN}/usr/bin

FROM alpine:3.20
#
RUN apk add --update --no-cache bash ca-certificates fuse

ARG GCSFUSE_BIN="/gcsfuse"
COPY --from=gcsfuse-package ${GCSFUSE_BIN}/usr/bin/gcsfuse /bin/
COPY --from=gcsfuse-package ${GCSFUSE_BIN}/sbin/mount.gcsfuse /sbin/

RUN apk add --no-cache fio==3.36-r0

COPY fio_jobs /jobs
COPY mount_configs /configs

VOLUME /data
WORKDIR /data
RUN mkdir /data/mnt

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
