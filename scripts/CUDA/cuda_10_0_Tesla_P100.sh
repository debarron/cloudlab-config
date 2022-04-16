#!/bin/bash

CUDA_VERSION="10.0"
CUDA_TOOLKIT_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.0.130-1_amd64.deb"
CUDA_PKG="cuda-repo-ubuntu1604_10.0.130-1_amd64.deb"
CUDA_KEY_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub"
NVIDIA_ML_URL="http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb"
NVIDIA_ML_PKG="nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb"

# Download and Install Cuda Toolkit
wget $CUDA_TOOLKIT_URL && wget $NVIDIA_ML_URL
sudo apt-key adv --fetch-keys $CUDA_KEY_URL && \
sudo apt-get update && \
sudo apt install ./$CUDA_PKG && \
sudo apt install ./$NVIDIA_ML_PKG && \
sudo apt-get update

# Download and install Nvidia driver.
sudo apt install nvidia-361-dev
sudo apt install cuda-10-0 \
    libcudnn7=7.4.1.5-1+cuda10.0  \
    libcudnn7-dev=7.4.1.5-1+cuda10.0
sudo apt update

# Install Tensorflow.
sudo apt-get install python3-pip
pip3 install tensorflow-gpu

# Add to Path.
export PATH=/usr/local/cuda-$CUDA_VERSION/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
exec /bin/bash