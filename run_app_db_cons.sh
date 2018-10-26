# name of docker image and container with application:
export NAME_DJANGOBLOG=djangoblog

# run container of mysql database, version 5.7:
echo "*********************************************************"
echo "*********************************************************"
echo "****             RUNNING CONTAINER WITH MYSQL DB      ***"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker run -d -p 3306:3306 --name db --restart always -v /opt/mysql-dj/data:/var/lib/mysql\
    -e MYSQL_ROOT_PASSWORD=mysqladmin \
    -e MYSQL_USER=django \
    -e MYSQL_PASSWORD=mysqladmin \
    -e MYSQL_DATABASE=django1 mysql:5.7
echo ""
echo "*********************************************************"
echo "*********************************************************"
echo "**** CONTAINER WITH MYSQL DB WAS CREATED SUCCESSFULLY ***"
echo "*********************************************************"
echo "*********************************************************"
echo ""

# build application image based on Dockerfile from subdirectory app/:
echo "*********************************************************"
echo "*********************************************************"
echo "****          BUILDING IMAGE OF APPLICATION          ****"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker build -t $NAME_DJANGOBLOG:1.0 -f app/Dockerfile .
echo ""
echo "*********************************************************"
echo "*********************************************************"
echo "****  IMAGE OF APPLICATION WAS CREATED SUCCESSFULLY  ****"
echo "*********************************************************"
echo "*********************************************************"
echo ""

# run application container based on image of application, publish on 8001 port:
echo "*********************************************************"
echo "*********************************************************"
echo "****         RUNNING CONTAINER WITH APPLICATION       ***"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker run -d --name $NAME_DJANGOBLOG -p 8001:8000 --link db:db --restart always $NAME_DJANGOBLOG:1.0
echo ""
echo "*********************************************************"
echo "*********************************************************"
echo "** CONTAINER WITH APPLICATION WAS CREATED SUCCESSFULLY **"
echo "*********************************************************"
echo "*********************************************************"
echo ""

# execute sh script inside application container - migration and creation of
# superuser for application:
echo "*********************************************************"
echo "*********************************************************"
echo "**   MIGRATION AND CREATION OF APPLICATION SUPERUSER   **"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker exec -it $NAME_DJANGOBLOG bash ./set_server.sh
echo "*********************************************************"
echo "*********************************************************"
echo ""

# build nginx-server image with new conf file:
echo "*********************************************************"
echo "*********************************************************"
echo "****          BUILDING IMAGE OF NGINX SERVER         ****"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker build -t nginx-dj:1.0 -f nginx/Dockerfile .
echo ""
echo "*********************************************************"
echo "*********************************************************"
echo "****  IMAGE OF APPLICATION WAS CREATED SUCCESSFULLY  ****"
echo "*********************************************************"
echo "*********************************************************"
echo ""

# run nginx-server based on created image nginx-dj:1.0:
echo "*********************************************************"
echo "*********************************************************"
echo "****         RUNNING CONTAINER WITH NGINX SERVER      ***"
echo "*********************************************************"
echo "*********************************************************"
echo ""
docker run -d --name nginx -p 80:80 --link $NAME_DJANGOBLOG:web --restart always nginx-dj:1.0 
echo ""
echo "*********************************************************"
echo "*********************************************************"
echo "* CONTAINER WITH NGINX SERVER WAS CREATED SUCCESSFULLY **"
echo "*********************************************************"
echo "*********************************************************"
echo ""

# delete application container:
# docker rm --force $NAME_DJANGOBLOG
# delete db container:
# docker rm --force db
# delete image of application:
# docker image rm --force $NAME_DJANGOBLOG:1.0
