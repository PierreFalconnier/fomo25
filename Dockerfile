# Base: NGC PyTorch image (matches CSCS Alps ngc-pytorch+25.06.sqsh)
# Includes: CUDA, cuDNN, Python, PyTorch, torchvision — all pre-configured
FROM nvcr.io/nvidia/pytorch:25.06-py3

# Maintainer
LABEL maintainer="Jaume Banus <jaume.banus-cobo@chuv.ch>"

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FOMO25_WEIGHTS_PATH=/usr/src/weights/fomo25_mmunetvae_pretrained.ckpt

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y \
        build-essential \
        ca-certificates \
        pkg-config \
        automake \
        autoconf \
        libtool \
        cmake \
        gdb \
        strace \
        wget \
        git \
        bzip2 \
        python3 \
        gfortran \
        rdma-core \
        numactl \
        libconfig-dev \
        libuv1-dev \
        libfuse-dev \
        libfuse3-dev \
        libyaml-dev \
        libnl-3-dev \
        libnuma-dev \
        libsensors-dev \
        libcurl4-openssl-dev \
        libjson-c-dev \
        libibverbs-dev \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ARG gdrcopy_version=2.5.1
RUN git clone --depth 1 --branch v${gdrcopy_version} https://github.com/NVIDIA/gdrcopy.git \
    && cd gdrcopy \
    && export CUDA_PATH=/usr/local/cuda \
    && make CC=gcc CUDA=$CUDA_PATH lib \
    && make lib_install \
    && cd ../ && rm -rf gdrcopy

# Install libfabric
ARG libfabric_version=1.22.0
RUN git clone --branch v${libfabric_version} --depth 1 https://github.com/ofiwg/libfabric.git \
    && cd libfabric \
    && ./autogen.sh \
    && ./configure --prefix=/usr --with-cuda=/usr/local/cuda --enable-cuda-dlopen \
       --enable-gdrcopy-dlopen --enable-efa \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf libfabric

# Install UCX
ARG UCX_VERSION=1.19.0
RUN wget https://github.com/openucx/ucx/releases/download/v${UCX_VERSION}/ucx-${UCX_VERSION}.tar.gz \
    && tar xzf ucx-${UCX_VERSION}.tar.gz \
    && cd ucx-${UCX_VERSION} \
    && mkdir build \
    && cd build \
    && ../configure --prefix=/usr --with-cuda=/usr/local/cuda --with-gdrcopy=/usr/local \
       --enable-mt --enable-devel-headers \
    && make -j$(nproc) \
    && make install \
    && cd ../.. \
    && rm -rf ucx-${UCX_VERSION}.tar.gz ucx-${UCX_VERSION}

ARG nccl_tests_version=2.17.1
RUN wget -O nccl-tests-${nccl_tests_version}.tar.gz https://github.com/NVIDIA/nccl-tests/archive/refs/tags/v${nccl_tests_version}.tar.gz \
    && tar xf nccl-tests-${nccl_tests_version}.tar.gz \
    && cd nccl-tests-${nccl_tests_version} \
    && MPI=1 make -j$(nproc) \
    && cd .. \
    && rm -rf nccl-tests-${nccl_tests_version}.tar.gz

# Set work directory and copy project
WORKDIR /usr/src/
COPY . /usr/src/

# Install project dependencies (PyTorch already in base image)
RUN pip install --no-cache-dir -e ".[dev,test]"

# Verify weights exist (non-fatal warning if missing)
RUN test -f /usr/src/weights/fomo25_mmunetvae_pretrained.ckpt || echo "Warning: Pretrained weights not found"