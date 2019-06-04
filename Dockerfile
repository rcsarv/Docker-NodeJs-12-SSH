#NodeJS Redis with SSH
#Auther rc@sarv.com

FROM node:12.3.1

RUN npm install -g concurrently

#SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:PassWord@ChangeMe' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'ClientAliveInterval 300' >> /etc/ssh/sshd_config
RUN echo  'ClientAliveCountMax 10' >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
#Port for NodeJS if required
#EXPOSE 3000

WORKDIR /app

COPY app /app


CMD concurrently "sleep 5s; node /app/index.js" "/usr/sbin/sshd"
