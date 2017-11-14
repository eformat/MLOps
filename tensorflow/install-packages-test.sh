export CUDNN_VERSION=6.0.21
export NVIDIA_VISIBLE_DEVICES=all
export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs:$LD_LIBRARY_PATH
export NVIDIA_DRIVER_CAPABILITIES=compute,utility
export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
export CUDA_PKG_VERSION=8-0=8.0.61-1
export CUDA_VERSION=8.0.61
export NVIDIA_CUDA_VERSION=8.0.61

R --version
echo $LD_LIBRARY_PATH
echo $PATH
R --no-save - << EOF!
r = getOption("repos")
r["CRAN"] = "http://cran.csiro.au/"
options(repos = r)
install.packages("gpuR")
EOF!
