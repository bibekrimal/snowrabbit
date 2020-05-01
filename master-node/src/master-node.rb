#!/usr/bin/env ruby

require 'sinatra'
require 'mysql2'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  erb :index
end

