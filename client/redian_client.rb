$LOAD_PATH << '..'
$LOAD_PATH << '.'

require "redian"

require "xmlrpc/client"

class Redian::Client < XMLRPC::Client

  REDIAN_CLIENT_DEFAULT_HOST = "127.0.0.1"
  REDIAN_CLIENT_DEFAULT_METHOD = "/RPC3"
  REDIAN_CLIENT_DEFAULT_PORT = "10000"

  attr_accessor :login, :password

  # default constructor
  def initiliaze(host, method, port)
    
    super(host, method, port)
    
  end

  # constructor with defaults
  def self.with_defaults

    new(REDIAN_CLIENT_DEFAULT_HOST, REDIAN_CLIENT_DEFAULT_METHOD, REDIAN_CLIENT_DEFAULT_PORT)

  end

  # login to remote machine
  def remote_login

    result = call("redian.login", @login, @password)

    if result["success"] == true

      true
      
    else
      
      false
      
    end
    
  end

  # forward keyboard
  def send_key(modifier, key)

    # TODO:JK: implement me
    
  end

  # read remote PTY
  def retrieve_buffer()

    # TODO:JK: implement me

  end
  
end
