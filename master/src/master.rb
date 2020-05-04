#!/usr/bin/env ruby

$stdout.sync = true
require 'sinatra'
require 'ostruct'
require 'logger'
require 'sqlite3'
require 'sequel'

set :bind, '0.0.0.0'
set :port, 4567

LOGGER = Logger.new(STDOUT)
LOGGER.level = "debug"
DB = Sequel.sqlite('/tmp/testing.db')

# Initialize databases
unless DB.table_exists?(:metrics)
  DB.create_table :metrics do
    primary_key :id
    column :timestamp, Integer
    column :type, String
    column :name, String
    column :value, String
    column :source_site, String
    column :dest_site, String
    column :dest_ip, String
  end
end


# URL Actions
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

    table = DB[:metrics]
    table.insert(timestamp: metric.timestamp, type: metric.type,  name: metric.name, value: metric.value, source_site: metric.source_site, dest_site: metric.site, dest_ip: metric.ip)

    'OK'
  end
end
