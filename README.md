# nginx-local-tunnel

Ever used ngrok or serveo? That's what this is.

![diagram](/diagram.png?raw=true "Diagram")

# Instructions

On the host server, [install docker](https://docs.docker.com/install/).

## 1. Build the container image

```
git clone https://github.com/robzhu/nginx-local-tunnel
cd nginx-local-tunnel

# edit Dockerfile to set your own password
docker build -t my-local-tunnel .
```

## 2. Launch the container and connect with SSH

```
docker run -d -p 80:80 -p 2222:22 my-local-proxy

# note port 4000 is from tunnel.conf. If you changed that
# also change 4000 below.
ssh -R :4000:localhost:3000 -p 2222 admin@HOSTIP
```

## 3. Start the sample app on localhost

```
cd node-hello
npm i
node main.js
```
