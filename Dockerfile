# Base: NGC PyTorch image (matches CSCS Alps ngc-pytorch+25.06.sqsh)
# Includes: CUDA, cuDNN, Python, PyTorch, torchvision — all pre-configured
FROM nvcr.io/nvidia/pytorch:25.06-py3

# Maintainer
LABEL maintainer="Jaume Banus <jaume.banus-cobo@chuv.ch>"

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FOMO25_WEIGHTS_PATH=/usr/src/weights/fomo25_mmunetvae_pretrained.ckpt

# Set work directory and copy project
WORKDIR /usr/src/
COPY . /usr/src/

# Install project dependencies (PyTorch already in base image)
RUN pip install --no-cache-dir -e ".[dev,test]"

# Verify weights exist (non-fatal warning if missing)
RUN test -f /usr/src/weights/fomo25_mmunetvae_pretrained.ckpt || echo "Warning: Pretrained weights not found"