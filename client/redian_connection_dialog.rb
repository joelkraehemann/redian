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
