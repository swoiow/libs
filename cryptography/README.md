## How to do

> a. add this commands under Dockerfile.

```dockerfile
FROM pypy:3.6-slim AS cryptography

ARG MIRROR=mirrors.ustc.edu.cn
ARG SOURCES=/etc/apt/sources.list
ENV SRC_LINK=https://files.pythonhosted.org/packages/07/ca/bc827c5e55918ad223d59d299fff92f3563476c3b00d0a9157d9c0217449/cryptography-2.6.1.tar.gz

WORKDIR /whl
RUN set -ex \
    && sed -i 's/deb.debian.org/'$MIRROR'/g' $SOURCES \
    && apt-get update \
    && apt-get install -y --no-install-recommends build-essential curl libssl-dev libffi-dev python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /dist
RUN curl -sL $SRC_LINK --stderr - | tar zx &&\
    cd $(ls -d */) && \
    pip wheel . && \
    cp $(ls |grep .whl) /dist
```

> b. And then, copy it in the main stage.

```dockerfile
COPY --from=cryptography /dist /dist
RUN pip install /dist/cryptography*.whl
```