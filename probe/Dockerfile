FROM ruby:2.6
MAINTAINER me@jason.camp

RUN mkdir /app
ADD src /app/

RUN apt-get update
RUN apt-get -y install cron

# Development testing
RUN apt-get -y install rsyslog vim traceroute

RUN gem install sinatra
RUN gem install sqlite3
RUN gem install net-ping
RUN gem install mixlib-shellout

WORKDIR /app
CMD /app/probe.rb
