FROM ubuntu:16.04

RUN apt-get update -y

RUN apt-get install -y build-essential
RUN apt-get install -y make
RUN apt-get install -y curl
RUN apt-get install -y nodejs npm

ENV WORKDIR /src
WORKDIR ${WORKDIR}

ADD ./rustup.sh $WORKDIR
RUN ./rustup.sh -y
ENV PATH /root/.cargo/bin:$PATH

ADD Makefile $WORKDIR
RUN make install

ADD . $WORKDIR
