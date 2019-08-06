#!/bin/bash
STORAGE=/var/fdfs/logs/storaged.log
TRACKER=/var/fdfs/logs/trackerd.log
NGINX=/usr/local/nginx/logs/access.log

ID=`docker ps|grep fastdfs|awk '{print $1}'`
echo fastdfs.ID:$ID
echo 'Use param tracker|storage|nginx to see log of each service such as "./log.sh tracker". No param equals to "storage".'
CAT=$1
LOG=""
if [[ "${CAT}" = "tracker" ]];then
    LOG=${TRACKER}
    docker exec -it tracker /usr/bin/tail -f ${LOG}
elif [[ "${CAT}" = "nginx" ]]; then
    LOG=${NGINX}
    docker exec -it storage0 /usr/bin/tail -f ${LOG}
else 
    LOG=${STORAGE}
    docker exec -it storage0 /usr/bin/tail -f ${LOG}
fi

