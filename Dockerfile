
FROM ubuntu:16.04
MAINTAINER James Alastair McLaughlin <j.a.mclaughlin@ncl.ac.uk>

# Dependencies
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y \
	git \
	nodejs \
	npm \
	mongodb \
    && update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Create a new iser to run the processes we install
RUN useradd ubuntu -p ubuntu -m -s /bin/bash

# Install the hub directly from git
RUN cd /opt && git clone https://github.com/ICO2S/synbiohub.git --depth 1 --branch v1.0.0
RUN cd /opt/synbiohub && npm install && npm install -g forever
RUN chown -R ubuntu:ubuntu /opt/synbiohub

# Store the synbiohub config in a different directory so that we can mount it in a Docker volume
# Also store the MongoDB data directory externally to the container image
RUN mkdir /mnt/data \
	&& mv /opt/synbiohub/config.json /opt/synbiohub/default-config.json \
	&& ln -s /mnt/data/hub-config/config.json /opt/synbiohub/config.json \
	&& rm -r /var/lib/mongodb \
	&& ln -s /mnt/data/mongodb /var/lib/mongodb


# Here's a custom startup script that will run on container bootup
COPY startup.sh /
RUN chmod +x /startup.sh

# Default port of the synbiohub
EXPOSE 7777

ENTRYPOINT ["/startup.sh"]



