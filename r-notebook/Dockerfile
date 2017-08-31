FROM jupyter/r-notebook

# StefanoPicozzi@gmail.com start

USER root

RUN apt-get update && \
    apt-get install -y default-jre
    
RUN cd /home/jovyan && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.1.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.1.0-bin-hadoop2.7.tar && \
    mv spark-2.1.0-bin-hadoop2.7 spark

RUN cd /home/jovyan/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

# StefanoPicozzi@gmail.com end
