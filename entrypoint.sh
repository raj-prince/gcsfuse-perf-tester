#!/bin/sh

set -e

# This expects arguments with this order: (1) config.yaml (2) bucket-name (3) fio job

# Create mount directory.
mkdir /data/mnt

# Mount gcsfuse with given config and bucket name.
gcsfuse --implicit-dirs --config-file $1 $2 /data/mnt

# Create a sub_dir in the mount directory.
job_name=$3
sub_dir=$(basename "$job_name" .fio)
mkdir -p /data/mnt/$sub_dir

# Run the fio workload, by going inside the directory.
cd /data/mnt/$sub_dir
fio $3
cd -
