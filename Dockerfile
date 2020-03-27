FROM jrottenberg/ffmpeg:latest

RUN apt-get -yqq update && \
    apt-get -yqq --no-install-recommends install curl perl build-essential libltdl-dev ghostscript pkgconf libjpeg-dev libpng-dev libtiff-dev libwebp-dev libraw-dev libjxr-dev

WORKDIR /tmp/workdir
RUN curl -O https://imagemagick.org/download/ImageMagick.tar.gz && \
    mkdir imagemagick && tar xzf ImageMagick.tar.gz -C imagemagick --strip-components 1
    
WORKDIR /tmp/workdir/imagemagick
RUN ./configure
RUN make
RUN make install

COPY . /converter

RUN rm -rf /tmp/workdir && \
    apt-get -yqq purge curl perl build-essential libltdl-dev ghostscript pkgconf && \
    apt-get -yqq autoremove && \
    apt-get -yqq clean

ENV PATH="/converter:${PATH}"
CMD ["-h"]
ENTRYPOINT ["interface"]