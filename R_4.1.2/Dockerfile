FROM rocker/r-ver:4.1.2

# Set environment variables
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Add the deadsnakes PPA for newer Python versions and install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    dirmngr \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    less \
    wget \
    ca-certificates \
    fonts-texgyre \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libcairo2-dev \
    libxt-dev \
    libmagick++-dev \
    libssh2-1-dev \
    libpq-dev \
    libreadline-dev \
    xorg \
    xauth \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff-dev \
    libjpeg-turbo8-dev \
    python3.8 \
    python3.8-distutils \
    python3.8-dev \
    python3.8-venv \
    python3-pip \
    gfortran \
    libgit2-dev \
    libmariadb-dev \
    libsodium-dev \
    && rm -rf /var/lib/apt/lists/*

# Update alternatives to make Python 3.8 the default Python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Update pip to be specifically for Python 3.8 and install necessary Python packages
RUN python3.8 -m pip install --upgrade pip && \
    python3.8 -m pip install numpy cython scipy scikit-learn hmmlearn macs3

# Ensure MACS3 is in the PATH
ENV PATH="/usr/local/bin:$PATH"

# Set the default command to run R when the container starts
CMD ["R"]