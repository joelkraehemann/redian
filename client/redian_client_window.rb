$LOAD_PATH << '..'
$LOAD_PATH << '.'

require "redian"
require "redian_client"

require "gtk2"
require "vte"

require "redian_menubar"

class Redian::Client::Window < Gtk::Window

  REDIAN_CLIENT_WINDOW_DEFAULT_TITLE = "Redian Client"

  attr_accessor :menu_bar, :terminal
  
  def initialize(title)

    super(title)

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

