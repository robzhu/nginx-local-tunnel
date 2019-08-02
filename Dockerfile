FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openssh-server nginx
COPY tunnel.conf /etc/nginx/conf.d/

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Create a different root account to avoid conflict from known_hosts
RUN adduser admin
RUN echo 'admin:YOURPASSWORDHERE' | chpasswd
RUN usermod -aG sudo admin

EXPOSE 22 80

# Start nginx and sshd
CMD ["sh", "-c", "nginx && /usr/sbin/sshd -D"]