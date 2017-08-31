FROM https://raw.githubusercontent.com/radanalyticsio/openshift-spark/master/Dockerfile

# StefanoPicozzi start
USER root
RUN yum install -y R
RUN yum install -y wget
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar
# R install added just before USER 185 line
RUN yum install -y R git postgresql-devel
#Add jars needed for s3 access
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar
# Switch to the user 185 for OpenShift usage
USER 185
# StefanoPicozzi end

