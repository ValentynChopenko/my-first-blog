# name of docker image and container with application:
export NAME_DJANGOBLOG=djangoblog

# run container of mysql database, version 5.7:
docker run -d -p 3306:3306 --name db --restart always -v /opt/mysql-dj/data:/var/lib/mysql\
    -e MYSQL_ROOT_PASSWORD=mysqladmin \
    -e MYSQL_USER=django \
    -e MYSQL_PASSWORD=mysqladmin \
    -e MYSQL_DATABASE=django1 mysql:5.7

# build application image based on Dockerfile from subdirectory app/:
docker build -t $NAME_DJANGOBLOG:1.0 -f app/Dockerfile .

# run application container based on image of application, publish on 8001 port:
docker run -d --name $NAME_DJANGOBLOG -p 8001:8000 --link db:db --restart always $NAME_DJANGOBLOG:1.0

# execute sh script inside application container - migration and creation of
# superuser for application:
docker exec -it $NAME_DJANGOBLOG bash ./set_server.sh

# build nginx-server image with new conf file:
docker build -t nginx-dj:1.0 -f nginx/Dockerfile .

# run nginx-server based on created image nginx-dj:1.0:
docker run -d --name nginx -p 80:80 --link $NAME_DJANGOBLOG:web --restart always nginx-dj:1.0 

# delete application container:
# docker rm --force $NAME_DJANGOBLOG
# delete db container:
# docker rm --force db
# delete image of application:
# docker image rm --force $NAME_DJANGOBLOG:1.0
