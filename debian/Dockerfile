# doc: https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact

ARG IMAGE_TAG=$IMAGE_TAG

FROM ${IMAGE_TAG}

WORKDIR /whl

ARG MIRROR=mirrors.ustc.edu.cn
ARG SOURCES="/etc/apt/sources.list"

RUN set -ex \
    # && sed -i 's/http/https/g' $SOURCES \
    && sed -i 's/deb.debian.org/'$MIRROR'/g' $SOURCES \
    && apt-get update \
    && apt-get install -y --no-install-recommends build-essential dumb-init curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /dist

ENTRYPOINT ["dumb-init", "--"]
