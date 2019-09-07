FROM jgoerzen/debian-base-security
MAINTAINER gfa@zumbi.com.ar

RUN \
  apt update
RUN \
  apt dist-upgrade -y
RUN \
  apt -y install ruby-dev gems build-essential awscli python-pip

RUN \
  adduser --system --shell /bin/sh bolt

WORKDIR /home/bolt

COPY . /home/bolt/

RUN \
  rm -rf /home/bolt/.gem /home/bolt/logs /home/bolt/Gemfile.lock /home/bolt/bolt.yaml

RUN \
  mv -f /home/bolt/ecs/bolt.yaml /home/bolt/bolt.yaml

RUN \
  gem install bundler

RUN \
  bundler install

RUN \
  pip install yq

COPY ecs/decrypt-keys /usr/local/preinit/97-decrypt-keys

COPY ecs/run-bolt-in-ecs /usr/local/preinit/98-run-bolt-in-ecs

COPY ecs/shutdown /usr/local/preinit/99-shutdown
