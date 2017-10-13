FROM rocker/rstudio:latest

RUN sudo apt-get update
RUN sudo apt-get upgrade
RUN sudo sudo apt-get install -y default-jdk zlib1g-dev

RUN cd /opt && \
    rm -rf spark* && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.2.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.2.0-bin-hadoop2.7.tar && \
    mv spark-2.2.0-bin-hadoop2.7 spark

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

RUN userdel guest; exit 0

RUN useradd guest \
    && echo "guest:guest" | chpasswd \
    && mkdir /home/guest \
    && chown rstudio:guest /home/guest
