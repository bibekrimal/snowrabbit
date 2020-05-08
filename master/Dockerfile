FROM ruby:2.6
MAINTAINER me@jason.camp

RUN mkdir /app
ADD src /app/

RUN mkdir -p /var/lib/db

#RUN yum -y install mysql mysql-devel gcc gcc-c++

#RUN apk add --update ruby-dev mariadb-dev mariadb-libs
#RUN apk add --update ruby-mysql2
RUN apt-get -y update
RUN apt-get -y install sqlite


RUN gem install sinatra
RUN gem install sqlite3
#RUN gem install mysql2
#RUN gem install pg
RUN gem install sequel

WORKDIR /app
CMD /app/master.rb
