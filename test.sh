#!/bin/bash

set -e
cd "$(dirname "$(readlink -f "$0")")"

sudo docker rm -f qeda-ci || true
rm -rf qeda-cli

git clone https://github.com/qeda/qeda-cli.git --depth=1
mkdir -p qeda-cli/.cargo
echo -e "[target.x86_64-apple-darwin]\nlinker = \"x86_64-apple-darwin14-clang\"\nar = \"x86_64-apple-darwin14-ar\"\n" > qeda-cli/.cargo/config

sudo docker run -it -d --name qeda-ci qeda-ci /bin/bash
sudo docker cp qeda-ci:/root/compiler.tar.xz ./
sudo docker cp qeda-cli qeda-ci:/root/

sudo docker exec -w /root/qeda-cli -it qeda-ci cargo build --target=x86_64-apple-darwin
sudo docker exec -w /root/qeda-cli -it qeda-ci cargo build --target=x86_64-pc-windows-gnu

cd ..

rm -rf qeda-cli
