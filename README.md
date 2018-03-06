# Docker Nginx Build from scratch


## Quick Start

```
docker run -d --name docker-nginx  -p 443:443 -v YOUR_CONF_DIR:/usr/local/nginx/conf liudanking/docker-nginx:v1_tls_1.3 
```

You may use `conf` dir in this project for test, but you must update edit `conf/ssl/chained.pem` and `conf/ssl/domain.key`.

## Build Your Docker Image

```
cd docker-nginx
docker build -t TAG_NAME  .
```

