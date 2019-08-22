FROM ubuntu:16.04
# Default password, overwrite with "docker build ... --build-arg ROOTPW=password"
ARG ROOTPW=root

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN echo root:${ROOTPW} | chpasswd

# When starting the container, map a custom port (i.e. 2222) to 22
# 80 is exposed for SSL-terminated HTTP traffic, which we will reverse proxy to localhost
EXPOSE 22 80

# Start nginx
CMD ["/usr/sbin/sshd", "-D"]
