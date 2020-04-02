FROM ubuntu:18.04 as base


ENV COMMON_DEPS="ca-certificates \
                 fontconfig-config \
                 fonts-dejavu-core"

RUN apt-get -yqq update && \
    apt-get -yq --no-install-recommends install ${COMMON_DEPS} && \
    apt-get -yq autoremove && \
    apt-get -yq clean

FROM base as build

ENV MAKE_FLAGS="-j 2"
ENV BUILD_DEPS="autoconf \
                automake \
                build-essential \
                cmake \
                curl \
                ghostscript \
                libass-dev \
                libfdk-aac-dev \
                libfontconfig1-dev \
                libfreetype6-dev \
                libjpeg-dev \
                libjxr-dev \
                libltdl-dev \
                libmp3lame-dev \
                libnuma-dev \
                libogg-dev \
                libopus-dev \
                libpng-dev \
                libraw-dev \
                libssl-dev \
                libtheora-dev \
                libtiff-dev \
                libtool \
                libvorbis-dev \
                libvpx-dev \
                libwebp-dev \
                libx264-dev \
                libx265-dev \
                nasm \
                perl \
                pkgconf \
                texinfo \
                yasm \
                zlib1g-dev"

RUN apt-get -yqq update && \
    apt-get -yq --no-install-recommends install ${BUILD_DEPS}

WORKDIR /tmp/workdir/
# Compiled according to ffmpeg compilation guide for Ubuntu https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
RUN curl -O https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    mkdir ffmpeg && tar xjvf ffmpeg-snapshot.tar.bz2 -C ffmpeg --strip-components 1
WORKDIR /tmp/workdir/ffmpeg
RUN ./configure \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \  
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-openssl \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
RUN make ${MAKE_FLAGS}
RUN make install

WORKDIR /tmp/workdir
# Compiled according to ImageMagick's Advanced Unix installation guide https://imagemagick.org/script/advanced-unix-installation.php
RUN curl -O https://imagemagick.org/download/ImageMagick.tar.gz && \
    mkdir imagemagick && tar xzf ImageMagick.tar.gz -C imagemagick --strip-components 1
WORKDIR /tmp/workdir/imagemagick
RUN ./configure
RUN make ${MAKE_FLAGS}
RUN make install

RUN ldconfig /usr/local/lib
RUN mkdir -p /converter/lib && \
        ldd /usr/local/bin/ffmpeg | cut -d ' ' -f 3 | xargs -i cp {} /usr/local/lib/ && \
        ldd /usr/local/bin/magick | grep /usr/local/lib | cut -d ' ' -f 3 | xargs -i cp {} /usr/local/lib/ || : && \
        ldd /usr/local/bin/magick | grep /usr/lib | cut -d ' ' -f 3 | xargs -i cp {} /converter/lib/ || :

FROM base as final

COPY --from=build /converter/lib /usr/lib/
COPY --from=build /usr/local /usr/local/
RUN ldconfig /usr/local/lib
COPY . /converter

ENV PATH="/converter:${PATH}"
CMD ["-h"]
ENTRYPOINT ["interface"]
