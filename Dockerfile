# nkern/21cmfast_env Dockerfile
FROM ubuntu:16.04

MAINTAINER Nick Kern <nkern@berkeley.edu>

RUN apt-get update && apt-get upgrade -y --allow-unauthenticated

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --allow-unauthenticated \
        build-essential \
        curl \
        dvipng \
        git \
        g++ \
        gcc \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        make \
        module-init-tools \
        pkg-config \
        python \
        python-dev \
        python3 \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        texlive \
        texlive-latex-extra \
        vim \
        wget \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        astropy \
        pyDOE \
        corner \
        emcee \
        memory_profiler \
        && \
    python -m ipykernel.kernelspec

# Install GSL
RUN mkdir /gnu && \
    wget -q https://ftp.gnu.org/gnu/gsl/gsl-2.4.tar.gz && \
    tar -zxf gsl-2.4.tar.gz && \
    rm -f gsl-2.4.tar.gz && \
    cd gsl-2.4 && \
    ./configure --prefix=/gnu/gsl > gsl_log 2>&1 && \
    make >> gsl_log 2>&1 && \
    make install >> gsl_log 2>&1

# Install fftw_float
RUN mkdir /fftw_float && \
    curl -O http://www.fftw.org/fftw-3.3.6-pl2.tar.gz && \
    tar -zxf fftw-3.3.6-pl2.tar.gz && \
    rm -f fftw-3.3.6-pl2.tar.gz && \
    cd fftw-3.3.6-pl2 && \
    ./configure --enable-float  --enable-openmp --prefix=/fftw_float > fftw_log 2>&1 && \
    make >> fftw_log 2>&1 && \
    make install >> fftw_log 2>&1

# Download 21cmFAST
RUN git clone https://github.com/nkern/21cmFAST && \
    chmod -R 777 21cmFAST

# Download environment files
RUN git clone https://github.com/nkern/21cmfast_env

# Note that you need to run the environment.sh script in the 
# container in order to set proper env variables for 21cmFAST

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

# Run bash
CMD ["/bin/bash"]
