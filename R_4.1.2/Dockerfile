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
    curl \
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
    libgsl-dev \
    libxext-dev \
    libxrender-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff-dev \
    libjpeg-turbo8-dev \
    supervisor \
    python3.8 \
    python3.8-distutils \
    python3.8-dev \
    python3.8-venv \
    python3-pip \
    gfortran \
    libgit2-dev \
    libmariadb-dev \
    libsodium-dev \
    x11-apps \
    psmisc \
    sudo \
    libclang-dev \
    && rm -rf /var/lib/apt/lists/*

# Update alternatives to make Python 3.8 the default Python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Update pip to be specifically for Python 3.8 and install necessary Python packages
RUN python3.8 -m pip install --upgrade pip && \
    python3.8 -m pip install numpy cython scipy scikit-learn hmmlearn macs3

# Install devtools and BiocManager
RUN R -e "install.packages(c('devtools', 'BiocManager'), repos='https://cran.rstudio.com/')"

RUN R -e "devtools::install_github('GreenleafLab/ArchR', ref='dev', repos = BiocManager::repositories(), upgrade = 'never')"

RUN R -e "install.packages(c('Cairo', 'Seurat', 'shinythemes', 'rhandsontable', 'optparse', 'tidyverse'))"

RUN R -e "install.packages('BSgenome.Ggallus.NCBI.bGalGal1.mat.broiler.GRCg7b_1.0.1.tar.gz', repos = NULL, type = 'source')"

# Download and install RStudio Server for Ubuntu 20.04
COPY install_rstudio_mod3.sh /rocker_scripts/install_rstudio_mod3.sh

# Copy entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /rocker_scripts/install_rstudio_mod3.sh

# Set the entrypoint to the custom script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port for RStudio Server
EXPOSE 8787