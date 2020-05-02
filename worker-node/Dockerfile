FROM ruby:2.6
MAINTAINER me@jason.camp

RUN mkdir /app
ADD src /app/

COPY cron/worker-cron /etc/cron.d

RUN apt-get update
RUN apt-get -y install cron openrc
RUN rc-update add cron
RUN service cron start

RUN gem install sinatra
RUN gem install sqlite3


WORKDIR /app
#CMD /app/worker-node.rb
CMD /app/entrypoint.sh
