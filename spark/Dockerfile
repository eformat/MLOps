FROM radanalyticsio/openshift-spark

# StefanoPicozzi start

USER root

<<<<<<< HEAD
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar
=======
RUN yum install -y R wget
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79

# Add jars needed for AWS S3 access
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

<<<<<<< HEAD
rUN rm -rf /var/lib/yum/yumdb
rUN rm -rf /var/cache/yum
RUN yum update -y; yum clean all
RUN yum history sync
RUN yum clean dbcache
RUN yum makecache
RUN yum clean expire-cache
RUN yum install -y wget git postgresql R && yum clean all 
=======
RUN yum update -y; yum clean all
RUN yum install -y R git postgresql-devel
>>>>>>> 4da894581b88f727986f4608f794a8a664d02a79

# Switch back to the user 185 for OpenShift usage
USER 185

# StefanoPicozzi end

