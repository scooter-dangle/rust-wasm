FROM rust:1.37

RUN rustup target add wasm32-unknown-unknown

RUN cd /tmp \
      && curl \
      --location \
      https://github.com/rustwasm/wasm-pack/releases/download/v0.8.1/wasm-pack-v0.8.1-x86_64-unknown-linux-musl.tar.gz \
      | tar --extract --gunzip \
      && mv wasm-pack-v0.8.1-x86_64-unknown-linux-musl/wasm-pack /usr/bin/wasm-pack \
      && cd -

# Note: Should switch to using the official Mozilla MUSL build once https://github.com/mozilla/sccache/pull/471 is merged
RUN cd /tmp \
      && curl --location \
      https://github.com/scooter-dangle/sccache/releases/download/v0.1.1-s3-working/sccache-v0.1.1-s3-working-x86_64-unknown-linux-musl.tar.gz \
      | tar --extract --gunzip \
      && mv sccache-v0.1.1-s3-working-x86_64-unknown-linux-musl/sccache /usr/bin/sccache \
      && cd -

COPY ./sccache-wrapper.sh /usr/bin/sccache-wrapper.sh
ENV RUSTC_WRAPPER=sccache-wrapper.sh

ENV WORKDIR /src
WORKDIR ${WORKDIR}

ADD . $WORKDIR
