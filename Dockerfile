# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    libmicrohttpd-dev \
    libjansson-dev \
    libssl-dev \
    libsrtp2-dev \
    libsofia-sip-ua-dev \
    libglib2.0-dev \
    libopus-dev \
    libogg-dev \
    libcurl4-openssl-dev \
    liblua5.3-dev \
    pkg-config \
    gengetopt \
    libtool \
    automake \
    libnice-dev \
    gtk-doc-tools \
    wget \
    unzip && \
    apt-get clean

# Clone the Janus repository
RUN git clone https://github.com/meetecho/janus-gateway.git /opt/janus-gateway

# Set the working directory
WORKDIR /opt/janus-gateway

# Get the latest code
RUN git checkout v0.11.8

# Compile and install Janus
RUN sh autogen.sh && \
    ./configure --disable-websockets --disable-data-channels --disable-rabbitmq --disable-mqtt --prefix=/opt/janus && \
    make && \
    make install && \
    make configs

# Expose necessary ports
EXPOSE 8088 8089 10000-10200/udp

# Set the entrypoint
ENTRYPOINT ["/opt/janus/bin/janus"]
