FROM golang:1.22-alpine

ARG APP_PATH
WORKDIR ${APP_PATH}

RUN apk update && apk add git vim

COPY ./api/ ${APP_PATH}

ENTRYPOINT [ ".docker/entrypoint.sh" ]