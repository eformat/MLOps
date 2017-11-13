FROM gcr.io/tensorflow/tensorflow:latest-gpu

# Install R
# https://cran.rstudio.com/bin/linux/ubuntu/README.html
# Dockerfile xamplte at https://github.com/rocker-org/rocker-versioned/blob/master/r-ver/Dockerfile

RUN apt-get update
RUN apt-get install -y apt-transport-https 
RUN echo "deb http://cran.csiro.au/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated r-base r-base-dev
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update
RUN apt-get upgrade -y

# Install RStudio
# https://www.rstudio.com/products/rstudio/download-server/
# Dockerfile example at https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/Dockerfile

RUN apt-get install -y wget gdebi-core
RUN cd /tmp; wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
RUN cd /tmp; gdebi -n rstudio-server-1.1.383-amd64.deb

# Create rstudio user
RUN useradd rstudio \
    && echo "rstudio:rstudio" | chpasswd \
	&& mkdir /home/rstudio \
	&& chown rstudio:rstudio /home/rstudio \
	&& addgroup rstudio staff 

# Needed for R GPU tools
RUN apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev \
    python-virtualenv mlocate
# RUN cp /usr/local/cuda/lib64/*Open* /usr/lib/R/lib
RUN updatedb
RUN mkdir /etc/OpenCL; mkdir /etc/OpenCL/vendors; echo "libnvidia-opencl.so.1" >> /etc/OpenCL/vendors/nvidia.icd

# Launch rstudio-server
USER root
EXPOSE 8787
CMD /usr/lib/rstudio-server/bin/rserver --server-daemonize 0
