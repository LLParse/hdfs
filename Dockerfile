FROM mesosphere/mesos:0.22.1-1.0.ubuntu1404

RUN \
  apt-get update && \
  apt-get -y install gettext

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so
ENV HDFS_MESOS_VERSION 0.1.3

ADD build/hdfs-mesos-$HDFS_MESOS_VERSION /hdfs-mesos
ADD docker-conf/*.xml /hdfs-mesos/etc/hadoop/

WORKDIR /hdfs-mesos

CMD /hdfs-mesos/bin/hdfs-mesos
