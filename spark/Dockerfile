FROM radanalyticsio/openshift-spark

# StefanoPicozzi start

USER root

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

RUN yum install -y R wget

# Add jars needed for AWS S3 access
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

RUN yum update -y; yum clean all
RUN yum install -y R git postgresql-devel

# Switch back to the user 185 for OpenShift usage
USER 185

# StefanoPicozzi end

