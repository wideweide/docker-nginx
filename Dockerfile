FROM ubuntu:16.04

LABEL maintainer="liudanking@gmail.com"

# use proxy to speed up download
# ENV http_proxy='http://192.168.101.12:6152'
# ENV https_proxy='http://192.168.101.12:6152'

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

# openssl with TLSv1.3
RUN set -x \
	&& git clone -b 'OpenSSL_1_1_1-stable' --single-branch --depth 1 https://github.com/openssl/openssl.git openssl


# build and install nginx
RUN set -x \
	&& wget -c https://nginx.org/download/nginx-1.17.6.tar.gz \
	&& tar zxf nginx-1.17.6.tar.gz \
	&& cd nginx-1.17.6 && ls ../ \
	&& ./configure \
		--add-module=../ngx_brotli \
		--add-module=../nginx-ct-1.3.2 \
		--with-openssl=../openssl \
		--with-http_v2_module \
		--with-http_ssl_module \
		--with-http_gzip_static_module \
	&& make \
	&& make install

# ENV http_proxy=''
# ENV https_proxy=''

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

