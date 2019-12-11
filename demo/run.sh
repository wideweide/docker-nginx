docker stop note-app-quasar
docker rm note-app-quasar

docker run -itd --restart=always -p 443:443 -p 80:80 \
--name note-app-quasar \
-v $PWD/nginx/conf:/usr/local/nginx/conf \
-v $PWD/spa:/usr/local/nginx/html \
xy-nginx:latest
