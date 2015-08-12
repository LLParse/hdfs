#!/bin/bash

VERSION=0.22.1-1.0.ubuntu1404
SLAVES=6

docker run -d \
-p 2181:2181 \
-p 2888:2888 \
-p 3888:3888 \
garland/zookeeper

LINKS=
for num in `seq 1 $SLAVES`; do
  PORT=$((5050+$num))
  LINKS="$LINKS --link mesos-slave$num:mesos-slave$num"
  id=$(docker run -d \
    -p $PORT:$PORT \
    --name=mesos-slave$num \
    mesosphere/mesos-slave:$VERSION \
    --master=zk://docker:2181/mesos \
    --port=$PORT \
    --hostname=mesos-slave$num)
  host=$(echo $id | cut -c1-12)
  sleep 1
  ip=$(docker exec -it $host awk 'NR==1 {print $1}' /etc/hosts)
  echo "$ip $host"
done

#$LINKS \
docker run -d \
  -p 5050:5050 \
  --net=host \
  --name=mesos-master \
  mesosphere/mesos-master:$VERSION \
  --ip=192.168.59.103 \
  --zk=zk://docker:2181/mesos \
  --work_dir=/var/lib/mesos \
  --quorum=1


docker run -d \
  -p 8765:8765 \
  --name hdfs-mesos \
  mesosphere/hdfs-mesos

docker logs -f hdfs-mesos
