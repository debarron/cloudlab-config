#!/bin/bash

CUDA_VERSION="9.0"
CUDA_TOOLKIT_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb"
CUDA_PKG="cuda-repo-ubuntu1604_9.1.85-1_amd64.deb"
CUDA_KEY_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub"
NVIDIA_ML_URL="http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb"
NVIDIA_ML_PKG="nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb"

# Download and Install Cuda Toolkit
wget $CUDA_TOOLKIT_URL && wget $NVIDIA_ML_URL
sudo apt-key adv --fetch-keys $CUDA_KEY_URL && \
sudo apt install ./$CUDA_PKG && \
sudo apt install ./$NVIDIA_ML_PKG && \
sudo apt-get update && \
sudo apt-get install cuda

# Download and install Nvidia driver.
sudo apt install nvidia-361-dev
sudo apt install cuda9.0 cuda-cublas-9-0 cuda-cufft-9-0 cuda-curand-9-0 \
    cuda-cusolver-9-0 cuda-cusparse-9-0 libcudnn7=7.2.1.38-1+cuda9.0 \
    libnccl2=2.2.13-1+cuda9.0 cuda-command-line-tools-9-0
sudo apt update

# Install Tensorflow.
sudo apt-get install python3-pip
pip3 install tensorflow-gpu==1.12.0

# Add to Path.
export PATH=/usr/local/cuda-$CUDA_VERSION/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
exec /bin/bash
