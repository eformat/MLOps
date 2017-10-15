FROM radanalyticsio/openshift-spark

# StefanoPicozzi start

USER root

RUN yum install -y R wget

RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

# Add jars needed for AWS S3 access
RUN cd /opt/spark/jars && \
    wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar && \
    wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar

RUN rm -rf /var/lib/yum/yumdb
RUN rm -rf /var/cache/yum
RUN yum update -y; yum clean all
RUN yum history sync
RUN yum clean dbcache
RUN yum makecache
RUN yum clean expire-cache
RUN yum install -y R git postgresql-devel

# Switch back to the user 185 for OpenShift usage
USER 185

# StefanoPicozzi end

