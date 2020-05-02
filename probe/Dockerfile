FROM ruby:2.6
MAINTAINER me@jason.camp

RUN mkdir /app
ADD src /app/

RUN apt-get update
RUN apt-get -y install cron

# Development testing
RUN apt-get -y install rsyslog vim 

RUN gem install sinatra
RUN gem install sqlite3
RUN gem install net-ping

COPY cron/probe-cron /etc/cron.d

WORKDIR /app
#CMD /app/entrypoint.sh
#CMD ["/usr/sbin/cron", "-f", "-L15"]
CMD /app/probe-cron.rb
