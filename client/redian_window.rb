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

