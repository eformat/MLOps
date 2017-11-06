FROM rocker/rstudio:latest

RUN sudo apt-get update
RUN sudo apt-get upgrade
RUN sudo sudo apt-get install -y default-jdk zlib1g-dev

<<<<<<< HEAD
RUN cd /opt && rm -rf spark*
=======
RUN rm -rf /opt/spark*
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79

RUN cd /opt && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.1.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.1.0-bin-hadoop2.7.tar

RUN cd /opt && \
    wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz && \
    gunzip spark-2.2.0-bin-hadoop2.7.tgz && \
    tar xvf spark-2.2.0-bin-hadoop2.7.tar
      
RUN cp -r /opt/spark-2.2.0-bin-hadoop2.7 /opt/spark

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar
<<<<<<< HEAD


=======
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79
