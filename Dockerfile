# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libbz2-dev

## Add source code to the build stage.
ADD . /bsdiff
WORKDIR /bsdiff

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN ./autogen.sh
RUN ./configure
RUN make
RUN cp bsdiff input
RUN cp bsdiff output
#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /bsdiff/bsdiff /
COPY --from=builder /bsdiff/input /
COPY --from=builder /bsdiff/output /
