#!/bin/sh

#echo "Prepare... "
#apt-get update
#apt-get install -y --no-install-recommends curl

echo "1. 正在下载压缩包"
curl -sL $SRC_LINK --stderr - | tar zx

echo "2. cd 进入第一个文件夹"
cd $(ls -d */)

echo $(pwd)

echo "3. 开始 build whl"
pip wheel .

echo "4. 输出所有的 whl 文件"
cp $(ls |grep .whl) /dist
