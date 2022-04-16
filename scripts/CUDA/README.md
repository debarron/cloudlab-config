# CUDA Setup

To setup GPU support for Tensorflow (>=1.13.0) execute cuda_10_0_Tesla_P100.sh

```./cuda_10_0_Tesla_P100.sh```

To setup GPU support for Tensorflow (<1.13.0) execute cuda_9_0_Tesla_P100.sh

```./cuda_9_0_Tesla_P100.sh```

To verify installation 

```nvidia-smi```

In case of the error ```Failed to initialize NVML: Driver/library version mismatch``` follow the steps mentioned <a href="https://stackoverflow.com/questions/43022843/nvidia-nvml-driver-library-version-mismatch"> here </a>.

To verify if tensorflow is using GPU acceleration.

```import tensorflow as tf
with tf.Session() as sess:
	devices = sess.list_devices()
	print(devices)
```

## Note
The script is configured for NVIDIA TESLA P100 GPU's available on c240g5 hardwares of CloudLab Wisconsin with Ubuntu 16.04.

## Reference
https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation

https://www.tensorflow.org/install/gpu

https://www.nvidia.com/Download/index.aspx?lang=en-us
