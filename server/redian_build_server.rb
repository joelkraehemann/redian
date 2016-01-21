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

#!/usr/bin/ruby

$LOAD_PATH << '.'
$LOAD_PATH << 'client'

require_relative '../redian'
require_relative '../redian_build_command'

class Redian::BuildServer < Object

  include Redian::BuildCommand

  def run

    STDOUT << "Redian-Build-Server  Copyright (C) 2016  Joël Krähemann"
    STDOUT << "This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'."
    STDOUT << "This is free software, and you are welcome to redistribute it"
    STDOUT << "under certain conditions; type `show c' for details."
    
    
    current_command = nil
    
    while(current_command != nil &&
          current_command != :QUIT)

      # TODO:JK: implement me
      
    end

  end
  
end

build_server = Redian::BuildServer.new
build_server.run


