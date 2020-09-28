
# CI Helper Tools

This repository contains some CI helper tools.

## Docker Image

* Based on: [Ubuntu 20.04](https://hub.docker.com/layers/ubuntu/library/ubuntu/20.04/images/sha256-2e70e9c81838224b5311970dbf7ed16802fbfe19e7a70b3cbfa3d7522aa285b4?context=explore)
* [Rust](https://www.rust-lang.org/) (nightly version)
* [OSXCross](https://github.com/tpoechtrager/osxcross)
* [gcc-mingw-w64-x86-64](https://packages.ubuntu.com/focal/devel/gcc-mingw-w64-x86-64)
* [cargo-deb](https://github.com/mmstick/cargo-deb)

Build:

    make

Test

    make test

