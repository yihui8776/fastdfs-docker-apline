FROM alpine:3.6

LABEL maintainer "yihui8776@github.com"


ENV FASTDFS_PATH=/opt/fdfs \
    FASTDFS_BASE_PATH=/var/fdfs \
    FASTDFS_LOGS=/var/fdfs/logs \
    NGINX_PORT=8082 \
    FDFS_PORT=22122 \
    GROUP_NAME= \
    TRACKER_SERVER= \
    GROUP_COUNT=


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --virtual .build-deps git gcc libc-dev make wget perl bash \
    pcre-dev zlib-dev openssl-dev linux-headers gnupg libxslt-dev gd-dev  geoip-dev




RUN mkdir -p ${FASTDFS_PATH}
RUN mkdir -p ${FASTDFS_BASE_PATH}

#ADD source/libfastcommon-1.0.38.tar.gz  /opt/fdfs/
#ADD source/fastdfs-5.11.tar.gz /opt/fdfs/
#ADD source/fastdfs-nginx-module-1.20.tar.gz /opt/fdfs/
#ADD source/nginx-1.13.6.tar.gz /opt/fdfs/
ADD source  ${FASTDFS_PATH}

RUN chmod 777 /opt/fdfs/*

RUN     cd ${FASTDFS_PATH} \
        && tar zxf libfastcommon-1.0.38.tar.gz \
        && tar zxf fastdfs-5.11.tar.gz \
        && tar zxf fastdfs-nginx-module-1.20.tar.gz

RUN     cd ${FASTDFS_PATH}/libfastcommon-1.0.38/ \
        && ./make.sh \
        && ./make.sh install

RUN     cd ${FASTDFS_PATH}/fastdfs-5.11/ \
        && ./make.sh \
        && ./make.sh install



RUN     cd ${FASTDFS_PATH} \
        && tar zxf nginx-1.13.6.tar.gz \
        && chmod u+x ${FASTDFS_PATH}/fastdfs-nginx-module-1.20/src/config \
        && cd nginx-1.13.6 \
        && ./configure --add-module=${FASTDFS_PATH}/fastdfs-nginx-module-1.20/src \
        && make && make install


RUN rm -rf ${FASTDFS_PATH}/*
RUN apk del .build-deps gcc libc-dev make openssl-dev linux-headers curl gnupg libxslt-dev gd-dev geoip-dev
RUN apk add bash pcre-dev zlib-dev


ADD conf/client.conf /etc/fdfs/
ADD conf/http.conf /etc/fdfs/
ADD conf/mime.types /etc/fdfs/
ADD conf/storage.conf /etc/fdfs/
ADD conf/tracker.conf /etc/fdfs/
ADD conf/nginx.conf /etc/fdfs/
ADD conf/mod_fastdfs.conf /etc/fdfs

RUN  mkdir -p ${FASTDFS_BASE_PATH}/data


EXPOSE 22122 23000 8081 8889

VOLUME ["$FASTDFS_BASE_PATH", "/etc/fdfs"]

COPY start.sh /usr/bin/

RUN chmod 777 /usr/bin/start.sh

ENTRYPOINT ["/usr/bin/start.sh"]
#CMD ["tracker"]


