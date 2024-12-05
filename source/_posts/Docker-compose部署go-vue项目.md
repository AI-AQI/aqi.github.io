---
title: Docker-compose部署go+vue项目
date: 2024-12-04 17:43:30
tags:
- go
- docker
categories:
- 工作技术记录
---

### ⭐启动mysql

```
docker pull mysql:8.0.19
```

### ⭐启动后端

##### 1. 构建后端镜像

```
docker build --network host -t go-api-compose . -f Dockerfile.compose
```

```
构建时文件目录：
    ├── Dockerfile.compose  // 后端Dockerfile 使用docker-compose启动之前使用该dockerfile构建镜像
    └── src  // 后端代码
        ├── xxx
        └── wait-for-it.sh  //  构建时会复制进镜像，用于等待并检验mysql是否可连接
```
```
wait-for-it.sh
https://github.com/vishnubob/wait-for-it
```
```
Dockerfile.compose：
	FROM golang:alpine AS builder
	
	# 为我们的镜像设置必要的环境变量
	ENV GO111MODULE=on \
	    GOPROXY=https://goproxy.cn,direct \
	    CGO_ENABLED=0 \
	    GOOS=linux \
	    GOARCH=amd64
	
	# 移动到工作目录：/build
	WORKDIR /build
	
	# 将代码复制到容器中
	COPY . .
	
	# 下载依赖信息
	RUN go mod download
	
	# 将我们的代码编译成二进制可执行文件 app
	RUN go build -o app .
	
	###################
	# 接下来创建一个小镜像
	###################
	#FROM scratch
	#FROM debian:stretch-slim
	# FROM python:3.8-slim
	FROM python:3
	
	COPY ./nvm_tool /nvm_tool
	COPY ./wait-for-it.sh /
	
	# 从builder镜像中把/dist/app 拷贝到当前目录
	COPY --from=builder /build/app /
	
	# apt-get换源
	RUN touch /etc/apt/sources.list
	RUN echo "deb http://mirrors.ustc.edu.cn/kali kali main non-free contrib" > /etc/apt/sources.list
	
	# python3镜像是ubuntu 使用apt-get安装需要的包
	RUN apt-get install libgomp1
	
	RUN chmod 755 wait-for-it.sh
	
	# 需要运行的命令，构建docker-compose使用的镜像时需要注释掉ENTRYPOINT，因为需要先用wait-for-it.sh检验mysql是否可连接
	# ENTRYPOINT ["/app", "-c", "/config.yaml"]
	
```


1. 准备前端nginx配置
  ```
  文件目录：
      ├── nginx       // 前端nginx配置
      └── conf.d
          └── default.compose.conf
  ```
  ```
  default.compose.conf：
  	server {
  	    listen       80;
  	    server_name  localhost;
  	
  	    access_log  /var/log/nginx/host.access.log  main;
  	    error_log  /var/log/nginx/error.log  error;
  	
  	    client_max_body_size 0;
  	
  	    location / {
  	        root   /usr/share/nginx/html;
  	        index  index.html index.htm;
  	    }
  	
  	    location /api {
  	            rewrite  ^.+api/?(.*)$ /$1 break;
  	            proxy_pass http://api-compose:8778;
  	            proxy_redirect off;
  	            proxy_set_header Host $host;
  	            proxy_set_header X-Real-IP $remote_addr;
  	            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  	            proxy_send_timeout 3600;
  	            proxy_read_timeout 3600;
  	            proxy_connect_timeout 3600;
  	    }
  	
  	    error_page 404 /404.html;
  	            location = /40x.html {
  	    }
  	    error_page 500 502 503 504 /50x.html;
  	            location = /50x.html {
  	    }
  	}
  
  ```

2.4 启动

	docker-compose up
	docker-compose stop
	docker-compose logs
	docker-compose ps
	docker-compose down
	```
	启动时文件目录：
	    ├── config.compose.yaml  // 后端config配置文件 此时go连接mysql配置为  ` root:root@tcp(mysql8019:3306)/test?charset=utf8&parseTime=True&loc=Local&timeout=10s `
	    ├── docker-compose.yml   
	    ├── files     // 后端files挂载文件
	    ├── log       // 后端log挂载文件
	    ├── mysql_data        // mysql数据挂载文件，如果已有预制数据，使用docker cp mysql:/var/lib/mysql mysql_data命令导出已启动mysql容器的数据卷
	    └── web
	        ├── dist  // 前端打包
	        └── nginx       // 前端nginx配置
	            └── conf.d
	                └── default.compose.conf
	```
	```
	docker-compose.yml：
		# yaml 配置
		version: "3.3"
		services:
		  mysql8019:
		    image: "mysql:8.0.19"
		    container_name: mysql8019
		    ports:
		      - "3308:3306"
		    #command: "--default-authentication-plugin=mysql_native_password --init-file /data/application/init.sql"
		    environment:
		      TZ: Asia/Shanghai
		      MYSQL_ROOT_PASSWORD: "root"
		      #MYSQL_DATABASE: "nvm"
		    volumes:
		      - ./mysql_data:/var/lib/mysql
		  api-compose:
		    image: "go-api-compose:latest"
		    container_name: api-compose
		    privileged: true
		    #build: .
		    command: ["/wait-for-it.sh","mysql8019:3306","--","/app", "-c", "/config.yaml"]
		    depends_on:
		      - mysql8019
		    ports:
		      - "8778:8778"
		    volumes:
		      - ./config.compose.yaml:/config.yaml
		      - ./files:/files
		      - ./log:/log
		  nginx:
		    image: nginx:latest
		    container_name: web-compose
		    ports:
		      - "8009:80"
		    volumes:
		      - ./web/nginx/conf.d/default.compose.conf:/etc/nginx/conf.d/default.conf
		      - ./web/dist:/usr/share/nginx/html
		    depends_on:
		      - api-compose
	```
	ip:3308 访问mysql
	http://ip:8778 访问后端
	http://ip:8009 访问前端 
	http://ip:8009/api 访问后端
