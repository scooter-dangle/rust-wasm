FROM ubuntu:16.04

RUN apt-get update -y

RUN apt-get install -y build-essential
RUN apt-get install -y make
RUN apt-get install -y curl

ENV WORKDIR /src
WORKDIR ${WORKDIR}

ADD ./rustup.sh $WORKDIR
RUN ./rustup.sh -y
ENV PATH /root/.cargo/bin:$PATH

ENV TOOLCHAIN_DATE 2018-04-07-
ENV TOOLCHAIN nightly-${TOOLCHAIN_DATE}x86_64-unknown-linux-gnu

RUN rustup update
RUN rustup toolchain install ${TOOLCHAIN}
RUN rustup target add wasm32-unknown-unknown --toolchain ${TOOLCHAIN}
RUN cargo +${TOOLCHAIN} install wasm-bindgen-cli
RUN cargo +${TOOLCHAIN} install wasm-gc

ADD ./nodejs.sh $WORKDIR
RUN ./nodejs.sh
RUN apt-get install -y nodejs
RUN npm update

ADD . $WORKDIR
