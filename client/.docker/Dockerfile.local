FROM node:20-slim

ARG USER_NAME
ARG APP_PATH
USER ${USER_NAME}
WORKDIR ${APP_PATH}

RUN apt update
RUN apt-get install -y git locales
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

RUN npm install -g create-next-app@latest

ENTRYPOINT ["./.docker/entrypoint.sh"]