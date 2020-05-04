#!/usr/bin/env ruby

# This script runs once every few mins and pings all probe nodes
$stdout.sync = true
require 'net/ping'
require 'net/http'
require 'logger'
require 'mixlib/shellout'
require 'ostruct'

logger = Logger.new(STDOUT)
logger.level = "debug"
PROBE_SITE = ENV['PROBE_SITE']
MASTER_HOST = ENV['MASTER_HOST']
MASTER_PORT = ENV['MASTER_PORT']
PROBE_SECRET = ENV['PROBE_SECRET']

def send_metric(type, name, val, source_site, site, ip, timestamp, secret)

  uri = URI("http://#{MASTER_HOST}:#{MASTER_PORT}/send_metric")
  res = Net::HTTP.post_form(uri, 'type' => type,
                                 'name' => name,
                                 'val' => val,
                                 'source_site' => source_site,
                                 'site' => site,
                                 'ip' => ip,
                                 'time' => timestamp,
                                 'secret' => secret)
  puts res.body

end


# Make sure required vars are set
if MASTER_HOST.nil? || MASTER_HOST.empty?
  puts "ERROR, MASTER_HOST is not set! Exiting..."
  exit 1
end



while true
  # Send pang to master server along with secret

  # We got a pung back, let's get all sites

  # Parse returned json from master


  probe_sites = {}
  probe_sites['ord'] = "216.200.232.1"
  probe_sites['ams'] = "185.29.134.1"
  probe_sites['iad'] = "4.4.4.4"

  # Let's loop through the sites and ping ips
  probe_sites.each do |site, ip|
    logger.info("Pinging #{site} - #{ip}")

    ping_cmd = "ping -c 5 -i 1 #{ip}"
    ping = Mixlib::ShellOut.new(ping_cmd)
    ping.run_command

    # Parse out the output
    ping_out = OpenStruct.new
    ping_out.site = site
    ping_out.ip = ip

    ping.stdout.each_line do |line|
      line.chomp!
      if line.include?("packet loss")
        /^(\d+) packets transmitted, (\d+) received, ([0-9\.\-\/]+)\% packet loss, time \d+ms$/.match(line)
        ping_out.transmitted = $1
        ping_out.received = $2
        ping_out.packet_loss = $3
      elsif line.start_with?("rtt")
        /^rtt min\/avg\/max\/mdev \= ([0-9\.\-\/]+)\/([0-9\.\-\/]+)\/([0-9\.\-\/]+)\/([0-9\.\-\/]+) ms$/.match(line)
        ping_out.min = $1
        ping_out.avg = $2
        ping_out.max = $3
        ping_out.mdev = $4
      end
    end

    send_metric('ping', 'transmitted', ping_out.transmitted, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'received', ping_out.received, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'packet_loss', ping_out.packet_loss, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'rtt_min', ping_out.min, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'rtt_avg', ping_out.avg, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'rtt_max', ping_out.max, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
    send_metric('ping', 'rtt_mdev', ping_out.mdev, PROBE_SITE, ping_out.site, ping_out.ip, Time.now().to_i, PROBE_SECRET)
  end

  # Sleep for a bit before checking again
   sleep(60)
end
