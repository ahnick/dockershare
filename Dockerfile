FROM ubuntu
MAINTAINER Xan Nick "xan.nick@gmail.com"

# Add docker repos for latest docker-engine
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb http://apt.dockerproject.org/repo ubuntu-precise main" > /etc/apt/sources.list.d/docker.list

# Update needed packages & config
RUN apt-get update

# Install docker-engine
RUN apt-get install -y docker-engine

# Add Samba
RUN apt-get -qq install samba
ADD smb.conf /etc/samba/smb.conf
RUN groupadd -g 1003 samba
RUN useradd -g 1003 -u 1003 samba

# Add script for symlinking containers
ADD share.sh /share.sh
RUN ln -s /share.sh /bin/share

# Some sane settings in case we enter the container
RUN echo "set -o vi" >> /root/.bashrc
RUN echo "export TERM=xterm" >> /root/.bashrc

# Create a directory to expose out the containers via the Samba share
RUN mkdir /containers

# Add Entrypoint to start Samba
ENTRYPOINT /usr/sbin/smbd -FS < /dev/null
