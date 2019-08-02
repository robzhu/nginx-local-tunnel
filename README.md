# nginx-local-tunnel

Ever used ngrok or serveo? That's what this is.

![diagram](/diagram.png?raw=true "Diagram")

# Instructions

On the host server, [install docker](https://docs.docker.com/install/). Configure DNS to point to your host server's IP.

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
