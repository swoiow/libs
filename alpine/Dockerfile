# doc: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact

ARG IMAGE=python
ARG TAG=3.6-alpine

FROM ${IMAGE}:${TAG}

WORKDIR /whl

ARG MIRROR=mirrors.aliyun.com

RUN sed -i 's/http/https/g' /etc/apk/repositories \
    && sed -i 's/dl-cdn.alpinelinux.org/'$MIRROR'/g' /etc/apk/repositories \
    && apk add --no-cache dumb-init unzip curl build-base \
    && mkdir /dist

ENTRYPOINT ["dumb-init", "--"]
