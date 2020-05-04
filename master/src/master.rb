#!/usr/bin/env ruby

$stdout.sync = true
require 'sinatra'
require 'ostruct'
require 'logger'

set :bind, '0.0.0.0'
set :port, 4567

LOGGER = Logger.new(STDOUT)
LOGGER.level = "debug"

get '/' do
  'Welcome to the Snow Rabbit master node!'
end

get '/send_metric' do
  'Error, must POST to this endpoint'
end

post '/send_metric' do
  # Accepts a metric from a probe
  LOGGER.debug("Starting send_metric")
  metric = OpenStruct.new

  metric.type = params[:type]
  metric.name = params[:name]
  metric.value = params[:val]
  metric.source_site = params[:source_site]
  metric.site = params[:site]
  metric.ip = params[:ip]
  metric.timestamp = params[:time]
  metric.secret = params[:secret]

  # Let's make sure we have the correct secret
  if metric.secret != ENV['PROBE_SECRET']
    LOGGER.debug("secret failed, skipping")
    status 401
    'Forbidden'
  else
    LOGGER.debug("secret succeeded, continuing")
    LOGGER.debug("VALUE: #{metric}")
  end
end
