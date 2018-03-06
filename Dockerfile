FROM ubuntu:16.04

LABEL maintainer="liudanking@gmail.com"

RUN apt-get update

# dependency
RUN set -x \
	&& apt-get install build-essential libpcre3 libpcre3-dev zlib1g-dev unzip git -y

RUN apt-get install wget

# module nginx-ct
RUN set -x  \
	&& wget -O nginx-ct.zip -c https://github.com/grahamedgecombe/nginx-ct/archive/v1.3.2.zip \
	&& unzip nginx-ct.zip

# module ngx_brotli
RUN set -x \
	&& git clone https://github.com/google/ngx_brotli.git \
	&& cd ngx_brotli \
	&& git submodule update --init

# openssl 1.3
RUN set -x \
	# git clone -b master --single-branch https://github.com/openssl/openssl.git openssl 
	&& git clone -b tls1.3-draft-18 --single-branch https://github.com/openssl/openssl.git openssl

# build and install nginx
RUN set -x \
	&& wget -c https://nginx.org/download/nginx-1.13.9.tar.gz \
	&& tar zxf nginx-1.13.9.tar.gz \
	&& cd nginx-1.13.9 \
	&& ./configure --add-module=../ngx_brotli --add-module=../nginx-ct-1.3.2 --with-openssl=../openssl --with-openssl-opt='enable-tls1_3 enable-weak-ssl-ciphers' --with-http_v2_module --with-http_ssl_module --with-http_gzip_static_module \
	&& make \
	&& make install 

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

