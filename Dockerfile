FROM jrottenberg/ffmpeg:latest

RUN apt-get -yqq update && \
    apt-get -yqq --no-install-recommends install imagemagick

COPY . /converter

ENV PATH="/converter:${PATH}"

RUN apt-get -yqq autoremove && \
    apt-get -yqq clean

CMD ["-h"]
ENTRYPOINT ["interface"]