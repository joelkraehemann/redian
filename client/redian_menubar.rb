# coding: utf-8
$LOAD_PATH << '..'
$LOAD_PATH << '.'

require "redian"
require "redian_client"

require "gtk2"

class Redian::Client::MenuBar < Gtk::MenuBar

  attr_accessor :file_menu, :help_menu

  def initialize

    super()

    # file menu
    item = Gtk::MenuItem.new("_File")
    append(item)
    
    @file_menu = Gtk::Menu.new
    item.submenu = @file_menu

    item = Gtk::MenuItem.new("Quit")
    @file_menu.add(item)

    item.signal_connect("activate") do
      Gtk.main_quit
    end

    # help menu
    item = Gtk::MenuItem.new("_Help")
    append(item)

    @help_menu = Gtk::Menu.new
    item.submenu = @help_menu

    item = Gtk::MenuItem.new("About")
    @help_menu.add(item)

    item.signal_connect("activate") do

      about = Gtk::AboutDialog.new
      about.program_name = "Redian Client"
      about.version = Redian::REDIAN_VERSION
      about.authors = %w[Joël\ Krähemann]
      
      about.signal_connect("response") do

        about.destroy
        
      end
      
      about.show
      
    end
    
  end
  
end
