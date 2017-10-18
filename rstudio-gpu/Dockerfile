FROM stefanopicozzi/rstudio:latest

RUN cd /tmp && \
    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb

RUN cd /tmp && \
    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb

RUN apt-get install -y gnupg
 
RUN cd /tmp && \
    dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb && \
    apt-key add /var/cuda-repo-8-0-local-ga2/7fa2af80.pub && \
    dpkg -i cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb && \
    apt-get install -y cuda-8-0
    
