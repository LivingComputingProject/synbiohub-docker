
FROM ubuntu:16.04
MAINTAINER James Alastair McLaughlin <j.a.mclaughlin@ncl.ac.uk>

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y \
	git \
	nodejs \
	npm \
	mongodb \
    && update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

RUN useradd ubuntu -p ubuntu -m -s /bin/bash

RUN cd /opt && git clone https://github.com/ICO2S/synbiohub.git --depth 1 --branch v1.0.0
RUN cd /opt/synbiohub && npm install && npm install -g forever
RUN chown -R ubuntu:ubuntu /opt/synbiohub

COPY startup.sh /
RUN chmod +x /startup.sh

EXPOSE 7777

ENTRYPOINT ["/startup.sh"]



