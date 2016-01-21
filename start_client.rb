#!/usr/bin/ruby

$LOAD_PATH << '.'
$LOAD_PATH << 'client'

require "redian"
require "client/redian_window"

Gtk.init

window = Redian::Window.with_defaults
window.show_all

Gtk.main
