# FastDFS Docker

Usage:
```
docker run -dti --network=host --name tracker -v /var/fdfs/tracker:/var/fdfs yihui8776/fastdfs-docker-apline  tracker

docker run -dti --network=host --name storage0 -e TRACKER_SERVER=120.24.197.36:22122 -e -v /var/fdfs/storage0:/var/fdfs yihui8776/fastdfs-docker-apline  storage

docker run -dti --network=host --name storage1 -e TRACKER_SERVER=120.24.197.36:22122 -e -v /var/fdfs/storage1:/var/fdfs yihui8776/fastdfs-docker-apline  storage

docker run -dti --network=host --name storage2 -e TRACKER_SERVER=120.24.197.36:22122 -e GROUP_NAME=group2 -e PORT=22222 -v /var/fdfs/storage2:/var/fdfs yihui8776/fastdfs-docker-apline  storage
```
