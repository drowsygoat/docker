# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean

# Download PLINK 2.0 binary
RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_avx2_20240820.zip -O /tmp/plink2.zip && \
    unzip /tmp/plink2.zip -d /usr/local/bin/ && \
    rm /tmp/plink2.zip

# Set executable permissions
RUN chmod +x /usr/local/bin/plink2

# Add /usr/local/bin to PATH
ENV PATH="/usr/local/bin:${PATH}"

# Set up a working directory
WORKDIR /data

# Default command (can be overridden by user)
CMD ["plink2", "--help"]
