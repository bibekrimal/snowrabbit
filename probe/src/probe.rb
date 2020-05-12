#!/usr/bin/env ruby

# This script runs once every few mins and pings all probe nodes
$stdout.sync = true
require 'net/ping'
require 'net/http'
require 'logger'
require 'mixlib/shellout'
require 'ostruct'
require 'json'

LOGGER = Logger.new(STDOUT)
LOGGER.level = "debug"
PROBE_SITE = ENV['PROBE_SITE']
MASTER_HOST = ENV['MASTER_HOST']
MASTER_PORT = ENV['MASTER_PORT']
PROBE_SECRET = ENV['PROBE_SECRET']

def send_pang
  uri = URI("http://#{MASTER_HOST}:#{MASTER_PORT}/pang")
  begin
    res = Net::HTTP.post_form(uri, 'name' => 'pang',
                                   'site' => PROBE_SITE,
                                   'secret' => PROBE_SECRET)

    if res.code == "200"
      return true
    else
      return false
    end
  rescue
    LOGGER.error("send_pang timed out")
    return false
  end
end

def get_probe_sites
  uri = URI("http://#{MASTER_HOST}:#{MASTER_PORT}/get_probes")
  probe_sites = {}

  begin
    res = Net::HTTP.post_form(uri, 'secret' => PROBE_SECRET)

    probe_sites = JSON.parse(res.body)
  rescue
    LOGGER.error("get_probe_sites timed out")
  end

  return probe_sites
end



def send_ping_metric(ping_vals)

  # Assume val is an ostruct and build a variable list
  LOGGER.debug("Sending ping metric")

  uri = URI("http://#{MASTER_HOST}:#{MASTER_PORT}/send_metric")
  begin
    res = Net::HTTP.post_form(uri, 'name' => 'ping',
                                   'source_site' => PROBE_SITE,
                                   'site' => ping_vals.site,
                                   'ip' => ping_vals.ip,
                                   'transmitted' => ping_vals.transmitted,
                                   'received' => ping_vals.received,
                                   'packet_loss' => ping_vals.packet_loss,
                                   'min' => ping_vals.min,
                                   'avg' => ping_vals.avg,
                                   'max' => ping_vals.max,
                                   'mdev' => ping_vals.mdev,
                                   'time' => Time.now().to_i,
                                   'secret' => PROBE_SECRET)

    puts res.body
  rescue
    LOGGER.error("send_ping_metric timed out")
  end
end

# Make sure required vars are set
if MASTER_HOST.nil? || MASTER_HOST.empty?
  puts "ERROR, MASTER_HOST is not set! Exiting..."
  exit 1
end



while true
  # Send pang to master server along with secret
  LOGGER.info("Sending pang")
  if !send_pang
    LOGGER.info('Error, cannot reach master or secret failed!')
  else
    # We got a pung back, let's get all sites

    # Parse returned json from master
    probe_sites = get_probe_sites()

    # Let's loop through the sites and ping ips
    probe_sites.each do |site, ip|
      unless site == PROBE_SITE
        LOGGER.info("Pinging #{site} - #{ip}")

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

        send_ping_metric(ping_out)
      end
    end
  end
  # Sleep for a bit before checking again
  sleep(60)
end

