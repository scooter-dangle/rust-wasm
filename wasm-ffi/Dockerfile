FROM apiaryio/emcc

RUN apt-get update -y

RUN apt-get install -y build-essential
RUN apt-get install -y make
RUN apt-get install -y curl

ENV WORKDIR /src
WORKDIR ${WORKDIR}

ADD ./wasm-ffi/rustup.sh $WORKDIR
RUN ./rustup.sh -y
ENV PATH /root/.cargo/bin:$PATH

RUN rustup target add asmjs-unknown-emscripten --toolchain stable
RUN rustup target add wasm32-unknown-emscripten --toolchain stable

ADD . $WORKDIR
