#!/usr/bin/env ruby

require 'sinatra'
require 'ostruct'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
#  erb :index
  'Welcome to the Snow Rabbit master node!'
end

get '/send_metric' do
  'Error, must post to this endpoint'
end

post '/send_metric' do
  # Accepts a metric from a probe
  metric = OpenStruct.new

  metric.type = params[:type]
  metric.name = params[:name]
  metric.value = params[:val]
  metric.source_site = params[:source_site]
  metric.site = params[:site]
  metric.timestamp = params[:time]
  metric.secret = params[:secret]


  puts "VALUE: #{metric}"
end
