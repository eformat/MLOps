
tensorflow:latest-gpu
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"

/etc/apt/sources.list
deb https://https://cran.csiro.au/bin/linux/ubuntu xenial/

# Install R
https://cran.rstudio.com/bin/linux/ubuntu/README.html

echo "deb http://cran.csiro.au/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list
apt-get update
apt-get install -y r-base
apt-get install -y r-base-dev
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
apt-get install -y apt-transport-https
apt-get update
apt-get upgrade -y

# Install RStudio
https://www.rstudio.com/products/rstudio/download-server/

apt-get install -y wget
apt-get install -y gdebi-core
wget https://download2.rstudio.org/rstudio-server-1.1.383-amd64.deb
gdebi -y rstudio-server-1.1.383-amd64.deb
rstudio-server verify-installation

USER root
EXPOSE 8787
CMD /usr/lib/rstudio-server/bin/rserver --server-daemonize 0



r-ver
https://github.com/rocker-org/rocker-versioned/blob/master/r-ver/Dockerfile

rstudio
https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/Dockerfile
