FROM ubuntu:20.04

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Dirk Eddelbuettel <edd@debian.org>"

# Set environment variables
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Add the deadsnakes PPA for newer Python versions and install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    dirmngr \
    && add-apt-repository ppa:deadsnakes/ppa

# Install dependencies for R and Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    ed \
    less \
    locales \
    vim-tiny \
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
    supervisor \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configure default locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8


# Add CRAN repository for R
RUN apt-get update && apt-get install -y --no-install-recommends \
	dirmngr \
	gnupg \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 \
	&& add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

# Ensure the necessary directories exist
RUN mkdir -p /usr/local/lib/R/etc && \
    mkdir -p /library && \
    echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site && \
    echo "R_LIBS_SITE=/library:\${R_LIBS_SITE}" >> /usr/local/lib/R/etc/Renviron.site

# Update alternatives to make Python 3.8 the default Python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 	1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Update pip to be specifically for Python 3--upgrade pip && \
    python3.8 -m pip install numpy cython scipy scikit-learn hmmlearn macs3

# Install R
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    littler \
    r-cran-littler \
    r-base=4.1.2-* \
    r-base-dev=4.1.2-* \
    r-base-core=4.1.2-* \
    && ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installBioc.r /usr/local/bin/installBioc.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installDeps.r /usr/local/bin/installDeps.r \
    && ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && install.r docopt \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

# Install devtools and BiocManager
RUN R -e "install.packages(c('devtools', 'BiocManager'), repos='https://cran.rstudio.com/')"

# Create the docker user
RUN useradd -m -s /bin/bash docker \
    && groupadd -f staff \
    && usermod -aG staff docker

# Install RStudio Server
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb && \
    apt-get install -y /rstudio-server-1.4.1717-amd64.deb && \
    rm /rstudio-server-1.4.1717-amd64.deb

# Create a user for RStudio
RUN useradd -m rstudio && echo "rstudio:rstudio" | chpasswd && adduser rstudio sudo

# Configure supervisord to manage RStudio Server
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8787

CMD ["/usr/bin/supervisord"]