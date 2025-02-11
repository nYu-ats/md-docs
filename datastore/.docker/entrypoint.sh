#!/bin/sh

gcloud config set project ${PROJECT_ID}

gcloud beta emulators datastore start \
  --data-dir=/datastore/.data \
  --host-port=${PORT}

exec "$@"