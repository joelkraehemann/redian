# coding: utf-8

# Redian-Build-Server - Interactive build server written in Ruby
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

require_relative '../redian'

module Redian::BuildCommand

  :SHOW_BUILD_COMMAND
  :QUIT
  :WARRANTY
  :COPYLEFT
  :OPEN_PACKAGE
  :NEW_PACKAGE
  :EDIT_BUILD
  :PTY_SESSION
  :BUILD_PACKAGE
  :BROWS_BUILDS
  
end
