#!/usr/bin/ruby

$LOAD_PATH << '.'
$LOAD_PATH << 'client'

require "redian"
require "client/redian_client_window"

Gtk.init

window = Redian::Client::Window.with_defaults
window.show_all

Gtk.main
