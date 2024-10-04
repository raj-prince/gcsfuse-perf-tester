# gcsfuse-perf-tester
GCSFuse performance tester.

## Steps to run the job
### Command to build the DockerFile
`docker build . -t <image_name>`

### Command to run the Docker image
`docker run <image_name> /jobs/read_cache.fio`

### Command to run the Docker image with shared volume
`docker run -v $HOST_VOLUME:/data` <image_name> /hobs/read_cache.fio