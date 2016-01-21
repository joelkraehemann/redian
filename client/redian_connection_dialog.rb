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
require "redian_client"

require "gtk2"

class Redian::Client::ConnectionDialog < Gtk::Dialog

  attr_accessor :server, :port,
                :login, :password
  
  def initialize

    super()

    table = Gtk::Table.new(4, 2, false)
    vbox().add(table)

    # server
    label = Gtk::Label.new("Server:")
    label.xalign = 0.0
    table.attach(label,
                 0, 1,
                 0, 1,
                 Gtk::FILL, Gtk::FILL,
                 0, 0)
    
    @server = Gtk::Entry.new
    table.attach(@server,
                 1, 2,
                 0, 1,
                 Gtk::EXPAND, Gtk::EXPAND,
                 0, 0)

    # port
    label = Gtk::Label.new("Port:")
    label.xalign = 0.0
    table.attach(label,
                 0, 1,
                 1, 2,
                 Gtk::FILL, Gtk::FILL,
                 0, 0)
    
    @port = Gtk::Entry.new
    table.attach(@port,
                 1, 2,
                 1, 2,
                 Gtk::EXPAND, Gtk::EXPAND,
                 0, 0)

    # login
    label = Gtk::Label.new("Login:")
    label.xalign = 0.0
    table.attach(label,
                 0, 1,
                 2, 3,
                 Gtk::FILL, Gtk::FILL,
                 0, 0)
    
    @login = Gtk::Entry.new
    table.attach(@login,
                 1, 2,
                 2, 3,
                 Gtk::EXPAND, Gtk::EXPAND,
                 0, 0)

    # password
    label = Gtk::Label.new("Password:")
    label.xalign = 0.0
    table.attach(label,
                 0, 1,
                 3, 4,
                 Gtk::FILL, Gtk::FILL,
                 0, 0)
    
    @password = Gtk::Entry.new
    @password.visibility = false
    table.attach(@password,
                 1, 2,
                 3, 4,
                 Gtk::EXPAND, Gtk::EXPAND,
                 0, 0)

    # dialog buttons
    add_buttons([Gtk::Stock::OK, Gtk::Dialog::RESPONSE_OK],
                [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL])
    
  end

end
