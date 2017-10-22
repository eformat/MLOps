FROM centos:latest

RUN yum install -y wget kernel-devel dkms

RUN cd /tmp; \
    wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm

RUN cd /tmp; \
    rpm --install cuda-repo-rhel7-9-0-local-9.0.176-1.x86_64-rpm

RUN yum install -y epel-release

RUN yum install -y kernel-devel dkms

RUN yum clean expire-cache; \
    yum install -y cuda

COPY cuda/include/cudnn.h /usr/local/cuda/include/cudnn.h

COPY cuDNN-v7.0/include/cudnn.h /usr/local/cuda/include/cudnn.h 
COPY cuDNN-v7.0/lib64/libcudnn.so /usr/local/cuda/lib64/libcudnn.so 
COPY cuDNN-v7.0/lib64/libcudnn.so.7.0.3 /usr/local/cuda/lib64/libcudnn.so.7.0.3 
COPY cuDNN-v7.0/lib64/libcudnn_static.a /usr/local/cuda/lib64/libcudnn_static.a 

COPY cuDNN-v6.0/lib64/libcudnn.so.6 /usr/local/cuda/lib64/libcudnn.so.6
COPY cuDNN-v6.0/lib64/libcudnn.so.6.0.21 /usr/local/cuda/lib64/libcudnn.so.6.0.21


RUN chmod a+r /usr/local/cuda/include/* /usr/local/cuda/lib64/*

RUN yum install -y cmake curl gcc gcc-c++ git make patch pciutils unzip

RUN export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; \
    echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc;

RUN yum -y update
RUN yum install -y python-pip python-devel; pip install --upgrade pip

RUN yum install -y git
RUN pip install tensorflow-gpu;

RUN cp /usr/local/cuda/lib64/libcusolver.so /usr/local/cuda/lib64/libcusolver.so.8.0; \
    cp /usr/local/cuda/lib64/libcublas.so /usr/local/cuda/lib64/libcublas.so.8.0; \
    cp /usr/local/cuda/lib64/libcufft.so /usr/local/cuda/lib64/libcufft.so.8.0; \
    cp /usr/local/cuda/lib64/libcurand.so /usr/local/cuda/lib64/libcurand.so.8.0; \
    cp /usr/local/cuda/lib64/libcudart.so /usr/local/cuda/lib64/libcudart.so.8.0

#RUN cd /home; \
#    git clone https://github.com/tensorflow/tensorflow.git; \
#    git clone https://github.com/tensorflow/models.git;

