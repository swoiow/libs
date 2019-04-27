#!/bin/sh

#echo "Prepare... "
#apt-get update
#apt-get install -y --no-install-recommends curl

echo "1. 正在下载压缩包"
for kv in `printenv |grep SRC`; do
  link=${kv#*=}
  echo "DOWNLOAD... $link"
  curl -sL "$link" --stderr - | tar zx
done

echo "2. cd 遍历文件夹"
for dir in `ls -d */`; do
  cd $dir
  echo "2.1 开始 build whl IN `pwd`"
  pip wheel .
  cd ..
done

echo "3. 输出所有的 whl 文件"
find . -type f | grep -i .whl | xargs -i cp {} /dist
