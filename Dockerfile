FROM jrottenberg/ffmpeg:latest

RUN apt-get -yqq update && \
    apt-get -y install imagemagick

COPY . /converter

WORKDIR /converter

RUN chmod +x interface

WORKDIR /output

CMD ["-h"]
ENTRYPOINT ["/converter/interface"]