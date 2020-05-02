#!/usr/bin/env ruby

# This script runs once every few mins and pings all probe nodes
$stdout.sync = true
require 'net/ping'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = "debug"

while true
  p = Net::Ping::TCP.new(host = "192.168.1.1")
  logger.info("PING: #{p.ping?}")
  puts "WTF"




   sleep(10)
end
