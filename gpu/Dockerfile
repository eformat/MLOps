FROM centos
# FROM registry.access.redhat.com/rhel7.4

RUN yum install -y cmake curl gcc gcc-c++ git make patch pciutils unzip

<<<<<<< HEAD
RUN yum install -y cuda; \ 
    export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; \
    echo -e 'export CUDA_HOME=/usr/local/cuda \n \
             export CUDA_PATH=${CUDA_HOME} \n \
             eexport PATH=${CUDA_HOME}/bin:${PATH} \n \
             export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH ' && \
    ~/.bashrc; \
=======
RUN yum install -y cuda; \
    export CUDA_HOME="/usr/local/cuda" CUDA_PATH="${CUDA_HOME}" PATH="${CUDA_HOME}/bin${PATH:+:${PATH}}" LD_LIBRARY_PATH="${CUDA_HOME}/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"; \
    echo -e 'export CUDA_HOME=/usr/local/cuda \nexport CUDA_PATH=${CUDA_HOME} \nexport PATH=${CUDA_HOME}/bin:${PATH} \nexport LD_LIBRARY_PATH=${CUDA_HOME}/lib64:/usr/local/lib:$LD_LIBRARY_PATH \n' >> ~/.bashrc; \
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79
    cd /tmp && \
    curl -fsSLO "http://developer.download.nvidia.com/compute/redist/cudnn/v6.0/cudnn-8.0-linux-x64-v6.0.tgz"; \
    tar -C /usr/local -zxf /tmp/cudnn-8.0-linux-x64-v6.0.tgz

<<<<<<< HEAD
RUN yum install -y python2*pip python-devel; pip install --upgrade pip
=======
RUN yum install -y epel-release
RUN yum -y update
RUN yum install -y python-pip python-devel; pip install --upgrade pip
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79

RUN pip install "https://github.com/Lasagne/Lasagne/archive/master.zip"

RUN yum install -y cmake3; cd /tmp && \
    git clone "https://github.com/Theano/libgpuarray.git"; \
<<<<<<< HEAD
    mkdir -p /tmp/libgpuarray/Build &&; \
=======
    mkdir -p /tmp/libgpuarray/Build && \
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79
    cd /tmp/libgpuarray/Build && \
    cmake3 .. -DCMAKE_BUILD_TYPE=Release && make && make install; \
    pip install Cython; cd /tmp/libgpuarray && \
    python setup.py build_ext -L /usr/local/lib64 -I /usr/local/include && \
    python setup.py install && ldconfig; \
<<<<<<< HEAD
    echo -e '[global] \n \
             device = cuda0 \n \
             floatX = float32 \n \
             [nvcc] \n \
             fastmath=True \n \
             [cuda] \n \
             root=/usr/local/cuda \n ' && \
    ~/.theanorc ; \
    pip install Theano

RUN curl https://raw.githubusercontent.com/Lasagne/Lasagne/master/examples/mnist.py -o /root/mnist.py

=======
    echo -e '[global] \ndevice = cuda0 \nfloatX = float32 \n[nvcc] \nfastmath=True \n[cuda] \nroot=/usr/local/cuda \n' >> ~/.theanorc ; \
    pip install Theano

RUN curl https://raw.githubusercontent.com/Lasagne/Lasagne/master/examples/mnist.py -o /root/mnist.py
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79
