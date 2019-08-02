# nginx-local-tunnel

This container lets you access an app running on localhost from a remote URL with SSL termination. This is helpful for testing integrations that require SSL, such as PWAs, Alexa Skills, Github WebHooks, etc. If you've ever used ngrok or serveo, this is just like that but with a little more control.

![diagram](/diagram.png?raw=true "Diagram")

# Instructions

## 0. Launch a Host Instance

Launch an Ubuntu 18.04 Virtual Private Server using any provider and open port 80. On the server, [install docker](https://docs.docker.com/install/). Configure DNS to point your domain to your host server's IP.

## 1. Build the container image

```
git clone https://github.com/robzhu/nginx-local-tunnel
cd nginx-local-tunnel

# edit Dockerfile to set your own password
# edit tunnel.conf to set your domain (include subdomain)
docker build -t my-local-tunnel .

# launch the container
docker run -d -p 80:80 -p 2222:22 my-local-proxy
```

## 2. On your dev machine, create a reverse tunnel with SSH

```
# Ports explained:
# 4000 is from tunnel.conf. If you changed that also change 4000 below.
# 3000 refers to the port that your app is running on localhost.
# 2222 is the forwarded port on the host that we use to directly SSH into the container.
ssh -R :4000:localhost:3000 -p 2222 admin@HOSTIP
```

## 3. Start the sample app on localhost

```
cd node-hello && npm i
nodemon main.js
```

Now you should be able to access your app from either http://localhost:3000 or http://YOURDOMAIN.com.

# SSL

On the server, launch [nginx-proxy](https://github.com/jwilder/nginx-proxy) and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion), then launch your container, specifying the subdomain.

```
docker run --detach \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --volume /etc/nginx/certs \
    --volume /etc/nginx/vhost.d \
    --volume /usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    jwilder/nginx-proxy

docker run --detach \
    --name nginx-proxy-letsencrypt \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env "DEFAULT_EMAIL=robzhu@gmail.com" \
    jrcs/letsencrypt-nginx-proxy-companion

docker run --detach \
    --name dev \
    --env "VIRTUAL_HOST=dev.YOURDOMAIN.tld" \
    --env "LETSENCRYPT_HOST=dev.YOURDOMAIN.tld" \
    my-local-proxy

```

On your local dev machine:

```
ssh -R :4000:localhost:3000 -p 2222 admin@YOURDOMAIN.tld
# run something on localhost:3000
```

Now you should be able to access your app from either http://localhost:3000 or https://dev.YOURDOMAIN.tld.
