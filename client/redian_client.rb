# coding: utf-8
# Redian-Client - Remote PTY Session for Redian-Server written in Ruby
# Copyright (C) 2016 Joël Krähemann
#
# This file is part of redian-client.
#
# Redian-Client is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Redian-Client is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Redian-Client.  If not, see <http://www.gnu.org/licenses/>.

$LOAD_PATH << '..'
$LOAD_PATH << '.'

require "redian"

require "xmlrpc/client"

class Redian::Client < XMLRPC::Client

  REDIAN_CLIENT_DEFAULT_HOST = "127.0.0.1"
  REDIAN_CLIENT_DEFAULT_METHOD = "/RPC3"
  REDIAN_CLIENT_DEFAULT_PORT = "10000"

  attr_accessor :login, :password

  # default constructor
  def initiliaze(host, method, port)
    
    super(host, method, port)
    
  end

  # constructor with defaults
  def self.with_defaults

    new(REDIAN_CLIENT_DEFAULT_HOST, REDIAN_CLIENT_DEFAULT_METHOD, REDIAN_CLIENT_DEFAULT_PORT)

  end

  # login to remote machine
  def remote_login

    result = call("redian.login", @login, @password)

    if result["success"] == true

      true
      
    else
      
      false
      
    end
    
  end

  # forward keyboard
  def send_key(modifier, key)

    # TODO:JK: implement me
    
  end

  # read remote PTY
  def retrieve_buffer()

    # TODO:JK: implement me

  end
  
end
