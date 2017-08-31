FROM centos:latest
MAINTAINER Stefano Picozzi

RUN yum -y install epel-release && \
    yum -y install R && \
    yum -y install wget

RUN wget https://download2.rstudio.org/rstudio-server-rhel-1.0.153-x86_64.rpm && \
    yum -y install rstudio-server-rhel-1.0.153-x86_64.rpm

RUN yum -y install mysql ftp curl libcurl libcurl-devel libpng-devel mesa-libGL-devel && \
    yum -y install mesa-libGLU-devel libpng-devel libxml2 libxml2-devel git openssl-devel && \
    yum -y install libpq-dev postgresql-libs postgresql-devel

RUN cd /opt && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.1.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.1.0-bin-hadoop2.7.tar && \
    mv spark-2.1.0-bin-hadoop2.7 spark

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

RUN useradd guest && \
    echo guest:guest | chpasswd && \
    useradd rstudio && \
    echo rstudio:rstudio | chpasswd && \
    useradd admin && \
    echo admin:admin | chpasswd

USER root

EXPOSE 8787
CMD /usr/lib/rstudio-server/bin/rserver --server-daemonize 0

