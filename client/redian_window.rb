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

require_relative "../redian"

require "gtk2"
require "vte"

require_relative "redian_client"
require_relative "redian_menubar"

class Redian::Window < Gtk::Window

  REDIAN_CLIENT_WINDOW_DEFAULT_TITLE = "Redian Client"

  attr_accessor :menu_bar, :terminal,
                :client
  
  def initialize(title)

    super(title)

    @client = Redian::Client.with_defaults
    
    vbox = Gtk::VBox.new
    add(vbox)

    # menubar
    @menu_bar = Redian::Client::MenuBar.new
    vbox.add(@menu_bar)

    # vte
    @terminal = Vte::Terminal.new
    vbox.add(@terminal)
    
    # signal handlers
    signal_connect("destroy") do

      Gtk.main_quit
      
    end
    
  end

  def self.with_defaults

    new(REDIAN_CLIENT_WINDOW_DEFAULT_TITLE)
    
  end
  
end

