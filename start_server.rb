#!/usr/bin/ruby

$LOAD_PATH << '.'
$LOAD_PATH << 'server'

require "redian"
require "server/redian_server"

server = Redian::Server.with_defaults
server.serve
