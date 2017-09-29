FROM rocker/rstudio:latest

RUN sudo apt-get update
RUN sudo apt-get upgrade
RUN sudo sudo apt-get install -y default-jdk

RUN cd /opt && \
    rm -f spark-2.1.0-bin-hadoop2.7* && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.1.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.1.0-bin-hadoop2.7.tar && \
    mv spark-2.1.0-bin-hadoop2.7 spark

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

# RUN sudo apt-get install gcc g++ gcc-4.9 g++-4.9 libxi libxi6 libxi-dev libglu1-mesa libglu1-mesa-dev libxmu6 libxmu6-dev linux-headers-amd64 linux-source
RUN sudo apt-get install -y gcc g++ libxi6 libxi-dev libglu1-mesa libglu1-mesa-dev libxmu6 linux-headers-amd64 linux-source
RUN sudo apt-get install -y gnupg gnupg2 gnupg1
RUN wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
RUN sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
RUN sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
RUN sudo apt-get update
# RUN sudo apt-get install -y cuda

RUN useradd guest && \
    echo guest:guest | chpasswd && \
    useradd admin && \
    echo admin:admin | chpasswd
