
tensorflow:latest-gpu
NAME="Ubuntu"
VERSION="16.04.3 LTS (Xenial Xerus)"

/etc/apt/sources.list
deb https://https://cran.csiro.au/bin/linux/ubuntu xenial/

echo "deb http://cran.csiro.au/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list
apt-get update
apt-get install -y r-base
apt-get install -y r-base-dev
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9



r-ver
https://github.com/rocker-org/rocker-versioned/blob/master/r-ver/Dockerfile

rstudio
https://github.com/rocker-org/rocker-versioned/blob/master/rstudio/Dockerfile
