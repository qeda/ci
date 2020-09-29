
# CI Helper Tools

[![Test Status](https://github.com/qeda/ci/workflows/Test/badge.svg)](https://github.com/qeda/ci/actions)

This repository contains some CI helper tools.

## Cross Compiler Tools

:point_right: https://github.com/qeda/ci/releases/download/compiler/compiler.tar.xz

* [OSXCross](https://github.com/tpoechtrager/osxcross)
* [gcc-mingw-w64-x86-64](https://packages.ubuntu.com/focal/devel/gcc-mingw-w64-x86-64)

Unpack:

    sudo tar -xf compiler.tar.xz -C /

Install prerequisites:

    sudo apt install -y clang g++ llvm libxml2

Compile:

    rustup target add x86_64-apple-darwin
    rustup target add x86_64-pc-windows-gnu

    # Linux
    cargo build

    # MacOS
    mkdir -p .cargo
    echo -e "[target.x86_64-apple-darwin]\nlinker = \"x86_64-apple-darwin14-clang\"\nar = \"x86_64-apple-darwin14-ar\"\n" > .cargo/config
    cargo build --target=x86_64-apple-darwin

    # Windows
    cargo build --target=x86_64-pc-windows-gnu

## Docker Image

Build:

    make

Test:

    make test
