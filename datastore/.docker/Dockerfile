FROM google/cloud-sdk:alpine

RUN apk add --update --no-cache openjdk21-jre \
    && gcloud components install cloud-datastore-emulator beta --quiet

COPY ./datastore /datastore

WORKDIR /datastore

ENTRYPOINT ["./.docker/entrypoint.sh"]