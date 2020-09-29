FROM ubuntu:20.04

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y clang cmake g++ gcc-mingw-w64-x86-64 git libssl-dev libxml2-dev llvm make p7zip pkgconf wget zlib1g-dev

WORKDIR /root
RUN git clone https://github.com/tpoechtrager/osxcross --depth=1

WORKDIR /root/osxcross
RUN wget -nc -P tarballs https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz
RUN UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh

WORKDIR /root

RUN mkdir -p usr/bin
RUN mkdir -p usr/lib/gcc/x86_64-w64-mingw32/9.3-win32
RUN mkdir -p usr/x86_64-w64-mingw32/lib
RUN mkdir -p usr/SDK/MacOSX10.10.sdk/System/Library/Frameworks
RUN mkdir -p usr/SDK/MacOSX10.10.sdk/usr/include/c++/4.2.1/
RUN mkdir -p usr/SDK/MacOSX10.10.sdk/usr/lib/system

# MacOS (Darwin) Tools
RUN cp -fv osxcross/target/bin/x86_64-apple-darwin14-ar usr/bin/
RUN cp -fv osxcross/target/bin/x86_64-apple-darwin14-clang usr/bin/
RUN cp -fv osxcross/target/bin/x86_64-apple-darwin14-ld usr/bin/
RUN cp -fv osxcross/target/lib/libxar.so.1 usr/lib/
RUN cp -frv osxcross/target/SDK/MacOSX10.10.sdk/System/Library/Frameworks/CoreFoundation.framework usr/SDK/MacOSX10.10.sdk/System/Library/Frameworks/
RUN cp -frv osxcross/target/SDK/MacOSX10.10.sdk/System/Library/Frameworks/Security.framework usr/SDK/MacOSX10.10.sdk/System/Library/Frameworks/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/system/*.dylib usr/SDK/MacOSX10.10.sdk/usr/lib/system/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/libc.dylib usr/SDK/MacOSX10.10.sdk/usr/lib/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/libm.dylib usr/SDK/MacOSX10.10.sdk/usr/lib/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/libresolv.dylib usr/SDK/MacOSX10.10.sdk/usr/lib/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/libSystem.dylib usr/SDK/MacOSX10.10.sdk/usr/lib/
RUN cp -fv osxcross/target/SDK/MacOSX10.10.sdk/usr/lib/crt1.10.6.o usr/SDK/MacOSX10.10.sdk/usr/lib/

# Windows (MinGW) Tools
RUN cp -fv /usr/bin/x86_64-w64-mingw32-ar usr/bin/
RUN cp -fv /usr/bin/x86_64-w64-mingw32-gcc usr/bin/
RUN cp -fv /usr/bin/x86_64-w64-mingw32-ld usr/bin/
RUN cp -fv /usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/libgcc.a usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/
RUN cp -fv /usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/libgcc_eh.a usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/
RUN cp -fv /usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/crtbegin.o usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libadvapi32.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libkernel32.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libmingw32.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libmingwex.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libmsvcrt.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libpthread.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libuser32.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libuserenv.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/libws2_32.a usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/crt2.o usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/crtbegin.o usr/x86_64-w64-mingw32/lib/
RUN cp -fv /usr/x86_64-w64-mingw32/lib/crtend.o usr/x86_64-w64-mingw32/lib/

RUN XZ_OPT=-9 tar cJf compiler.tar.xz usr

# Prepare environment for testing purposes
RUN wget https://sh.rustup.rs -O rustup-init.sh
RUN chmod +x rustup-init.sh && ./rustup-init.sh -y --target=x86_64-apple-darwin --target=x86_64-pc-windows-gnu
ENV PATH="/root/.cargo/bin:${PATH}"

RUN apt-get purge -y cmake gcc-mingw-w64-x86-64 git libssl-dev make p7zip pkgconf zlib1g-dev && apt-get autoremove -y
RUN cp -frv usr/* /usr/
