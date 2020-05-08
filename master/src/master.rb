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
DB_METRICS = Sequel.sqlite('/var/lib/db/metrics.db')
DB_PROBES = Sequel.sqlite('/var/lib/db/probes.db')

# Initialize databases
unless DB_METRICS.table_exists?(:ping_metrics)
  DB_METRICS.create_table :ping_metrics do
    primary_key :id
    column :timestamp, Integer
    column :source_site, String
    column :dest_site, String
    column :dest_ip, String
    column :transmitted, String
    column :received, String
    column :packet_loss, String
    column :min, String
    column :avg, String
    column :max, String
    column :mdev, String
  end
end

unless DB_PROBES.table_exists?(:probes)
  DB_PROBES.create_table :probes do
    primary_key :id
    column :site, String
    column :description, String
    column :location_lat, String
    column :location_long, String
    column :active, Integer
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

  metric.name = params[:name]
  metric.source_site = params[:source_site]
  metric.dest_site = params[:site]
  metric.ip = params[:ip]
  metric.timestamp = params[:time]
  metric.secret = params[:secret]

  if metric.name == "ping"
    metric.transmitted = params[:transmitted]
    metric.received = params[:received]
    metric.packet_loss = params[:packet_loss]
    metric.min = params[:min]
    metric.avg = params[:avg]
    metric.max = params[:max]
    metric.mdev = params[:mdev]
  end

  # Let's make sure we have the correct secret
  if metric.secret != ENV['PROBE_SECRET']
    LOGGER.debug("secret failed, skipping")
    status 401
    'Forbidden'
  else
    LOGGER.debug("secret succeeded, continuing")
    LOGGER.debug("VALUE: #{metric}")

    if metric.name == "ping"
      table = DB_METRICS[:ping_metrics]
      table.insert(timestamp: metric.timestamp,
                   source_site: metric.source_site,
                   dest_site: metric.dest_site,
                   dest_ip: metric.ip,
                   transmitted: metric.transmitted,
                   received: metric.received,
                   packet_loss: metric.packet_loss,
                   min: metric.min,
                   avg: metric.avg,
                   max: metric.max,
                   mdev: metric.mdev)
    end

    'OK'
  end
end

get '/list_metrics' do
  @ping_metrics = DB_METRICS[:ping_metrics].limit(10)
  erb :list_metrics
end

#13|1588945152|ping|rtt_max|359.407|ewr|ams|185.29.134.1
#14|1588945152|ping|rtt_mdev|90.184|ewr|ams|185.29.134.1
#15|1588945166|ping|transmitted|5|ewr|iad|4.4.4.4
#16|1588945166|ping|received|0|ewr|iad|4.4.4.4
#17|1588945166|ping|packet_loss|100|ewr|iad|4.4.4.4
#18|1588945166|ping|rtt_min||ewr|iad|4.4.4.4
#19|1588945166|ping|rtt_avg||ewr|iad|4.4.4.4
#20|1588945166|ping|rtt_max||ewr|iad|4.4.4.4
#21|1588945166|ping|rtt_mdev||ewr|iad|4.4.4.4
#sqlite> .schema
#CREATE TABLE `metrics` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `timestamp` integer, `type` varchar(255), `name` varchar(255), `value` varchar(255), `source_site` varchar(255), `dest_site` varchar(255), `dest_ip` varchar(255));
#

get '/list_probes' do
  table_probe = DB_PROBES[:probes]

  table_probe.all.each do |t|
    LOGGER.debug(t)
  end
end
