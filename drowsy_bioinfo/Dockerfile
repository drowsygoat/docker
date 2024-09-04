# Use the official Ubuntu base image
FROM ubuntu:latest

# Set the maintainer label (optional)
LABEL maintainer="lecka48@liu.se"

# Prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install required utilities
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    openjdk-11-jre-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the BBMap version and download link
ENV BBMAP_VERSION=39.08
ENV BBMAP_URL=https://sourceforge.net/projects/bbmap/files/BBMap_${BBMAP_VERSION}.tar.gz

ENV SEQKIT_VERSION=v2.8.2
ENV SEQKIT_URL=https://github.com/shenwei356/seqkit/releases/download/${SEQKIT_VERSION}/seqkit_linux_amd64.tar.gz

# Create the /bbmap directory
RUN mkdir -p /bbmap

# Download and extract BBMap
RUN wget $BBMAP_URL -O /tmp/bbmap.tar.gz \
    && tar -xzvf /tmp/bbmap.tar.gz -C /bbmap --strip-components=1 \
    && rm /tmp/bbmap.tar.gz

RUN wget $SEQKIT_URL -O /tmp/seqkit_linux_amd64.tar.gz \
    && tar -zxvf /tmp/seqkit_linux_amd64.tar.gz \
    && mv seqkit /usr/local/bin/ \
    && rm /tmp/seqkit_linux_amd64.tar.gz

# Add BBMap to the PATH
ENV PATH="/bbmap:$PATH"

# Set the working directory inside the container
WORKDIR /workspace

# to tun the singularity sandbox:
# singularity pull docker://drowsygoat/bbmap_suite:1.0.0
# singularity run --bind /cfs/klemming/projects/snic/sllstore2017078/lech:/mnt bbmap_sb bbmap.sh