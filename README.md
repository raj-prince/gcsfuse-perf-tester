# gcsfuse-perf-tester
GCSFuse performance tester.

## Steps to build and run the docker locally
1. Build the docker image
```agsl
docker build . -t <image_name>
```
2. Run the docker image
```agsl
docker run --device /dev/fuse --privileged <image_name> <mount_config_path> <bucket_name> <fio_job_path>
```

2. Run the docker image
```agsl
docker run  -v $HOST_VOLUME:/data` --device /dev/fuse --privileged <image_name> <mount_config_path> <bucket_name> <fio_job_path>
```

## Steps to push the image on cloud registry
1. Build the docker image
```agsl
docker build . -t <image_name>
```
2. Tag the docker image
```agsl
docker tag <image_name> <artifactory_path>/imagename

E.g.,
docker tag <image_name> us-west1-docker.pkg.dev/gcs-fuse-test/gcsfuse-perf-tester/gcsfuse-fio:0.0.5
```
3. Push the tagged image
```agsl
docker push <artifactory_path>/imagename

E.g., 
docker push us-west1-docker.pkg.dev/gcs-fuse-test/gcsfuse-perf-tester/gcsfuse-fio:0.0.5
```
4. Run the docker image (requires artifactory read authorization)
```agsl
sudo docker --config /home/princer_google_com/.docker run --device /dev/fuse --privileged  us-west1-docker.pkg.dev/gcs-fuse-test/gcsfuse-perf-tester/gcsfuse-fio:0.0.5 /configs/default.yaml princer-empty-bucket /jobs/presubmit_perf_test.fio
```