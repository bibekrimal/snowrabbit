FROM ruby:2.6
MAINTAINER me@jason.camp

RUN mkdir /app
ADD src /app/



#RUN yum -y install mysql mysql-devel gcc gcc-c++

#RUN apk add --update ruby-dev mariadb-dev mariadb-libs
#RUN apk add --update ruby-mysql2

RUN gem install sinatra
RUN gem install mysql2

WORKDIR /app
CMD /app/master.rb
