# build args
export IMAGE:=python
export TAG:=alpine
export MIRROR:=mirrors.aliyun.com

# build stage
export SRC_LINK:=https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz
export PRE_COMMAND:=apk add libffi-dev openssl-dev python3-dev

base-env:
	docker build \
	--build-arg IMAGE=$${IMAGE} \
	--build-arg TAG=$${TAG} \
	--build-arg MIRROR=$${MIRROR} \
	--build-arg SRC_LINK=$${SRC_LINK} \
	-t build_whl:$${TAG} .

build: base-env
	docker-compose -f docker-compose-4make.yml \
	up