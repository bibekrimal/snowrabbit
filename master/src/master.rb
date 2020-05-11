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
    column :secret, String
    column :active, Integer
  end
end


# URL Actions
get '/' do
  'Welcome to the Snow Rabbit master node!'
end

post '/pang' do
  # This will validate that a probe can reach the master and validates its secret
  # See if this probe is registered
  probes_registered= DB_PROBES[:probes].where(site: params[:site], active: 0..1)
  probes_unregistered = DB_PROBES[:probes].where(site: params[:site], active: 2)

  # See if this site is registered or unregistered
  pang_authed = false
  probes_registered.each do |probe|
    LOGGER.info("SECRETS: #{probe[:secret]} - #{params[:secret]}")
    if probe[:secret] == params[:secret]
      pang_authed = true
    end
  end

  # See if this probe is unregistered, if not mark it as unregistered
  if !pang_authed && (probes_unregistered.count == 0)
    DB_PROBES[:probes].insert(site: params[:site], active: 2)
  end

  if pang_authed
    'OK'
  else
    status 401
     'Unauthorized'
  end
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
  @ping_metrics = DB_METRICS[:ping_metrics].limit(50).order(Sequel.desc(:timestamp)) 
  erb :list_metrics
end


get '/list_probes' do
  @probes = DB_PROBES[:probes].where(active: 0..1)
  @probes_unregistered = DB_PROBES[:probes].where(active: 2)
  erb :list_probes

end


