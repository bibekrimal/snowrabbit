#!/usr/bin/env ruby

# This script runs once every 5 minutes and pings each worker node
require 'net/ping'

p = Net::Ping::TCP.new(host = "192.168.1.1")
p.ping?

puts p.inspect
