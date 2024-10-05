#!/bin/sh

gcsfuse --help
ls -lah /data
mkdir /data/mnt
gcsfuse --implicit-dirs --config-file /configs/default.yaml $2 /data/mnt

fio --directory /data/mnt $1
