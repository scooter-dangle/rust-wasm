FROM ubuntu:16.04

RUN apt-get update -y && \
      apt-get install -y \
    build-essential      \
    make                 \
    curl                 \
    libssl-dev           \
    pkg-config             # for cargo-web

ENV WORKDIR /src
WORKDIR ${WORKDIR}

ADD ./rustup.sh $WORKDIR
RUN ./rustup.sh -y
ENV PATH /root/.cargo/bin:$PATH

RUN rustup target add wasm32-unknown-emscripten --toolchain stable

RUN cargo install cargo-web
RUN cargo web prepare-emscripten

RUN apt-get install -y python
RUN apt-get install -y nodejs

ADD . $WORKDIR
