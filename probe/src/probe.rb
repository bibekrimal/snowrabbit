#!/usr/bin/env ruby

# This script runs once every few mins and pings all probe nodes
$stdout.sync = true
require 'net/ping'
require 'logger'
require 'mixlib/shellout'
require 'ostruct'

logger = Logger.new(STDOUT)
logger.level = "debug"

source_site = 'ewr'
source_ip = '1.2.3.4'


while true
  puts "ENV: #{ENV}"
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
    ping_out.source_site = source_site
    ping_out.source_ip = source_ip
    ping_out.site = site
    ping_out.ip = ip

    ping.stdout.each_line do |line|
      line.chomp!
      if line.end_with?("packet loss")
        /^(\d+) packets transmitted, (\d+) packets received, ([0-9\.\-\/]+)\% packet loss$/.match(line)
        ping_out.transmitted = $1
        ping_out.received = $2
        ping_out.packet_loss = $3
      elsif line.start_with?("round-trip")
        /^round-trip min\/avg\/max\/stddev \= ([0-9\.\-\/]+)\/([0-9\.\-\/]+)\/([0-9\.\-\/]+)\/([0-9\.\-\/]+) ms$/.match(line)
        ping_out.min = $1
        ping_out.avg = $2
        ping_out.max = $3
        ping_out.stddev = $4
      end
    end
    puts ping_out
  
  end

  # Sleep for a bit before checking again
   sleep(60)
end
