require "xmlrpc/server"

class RedianServer < XMLRPC::Server

  REDIAN_BUILD_HOST = "127.0.0.1"
  REDIAN_BUILD_PORT = 10000

  attr_accessor :account, :session
  
  # default constructor
  def initialize(host, port)

    super(host, port)

    account = Array.new
    session = Array.new
    
    # redian login handler
    add_handler("redian.login") do |username, password|

      login(username, password)
      
    end

    # redian logout handler
    add_handler("redian.logout") do |token|

      logout(token)
      
    end

    # TODO:JK: implement server
  end

  # with defaults constructor
  def with_defaults
    
    new(REDIAN_BUILD_HOST, REDIAN_BUILD_PORT)
    
  end

  # check access rights
  def authenticate(username, token, context, permission)

    # find session
    found_session = false
    
    session.each do |current|

      if(current.username == username &&
         current.token == token)

        found_session = true
        
        break
        
      end
      
    end

    # raise exception if no such session
    if !found_session

      raise ArgumentError.new("access denied")
      
    end

    # grant context
    access_granted = false

    account.each do |current|

      # find username
      if current.username == username

        current.security_context.each |current_context| do

          # find context
          if current_context.context == context

            # check permission
            if (current.permission & permission) == permission

              access_granted = true
              
            end
            
            break
                                             
          end
          
        end

        break
        
      end
      
    end

    # raise exception if no access rights
    if !access_granted

      raise ArgumentError.new("access denied")
      
    end

    # you got it
    true
    
  end
  
  # perform login to server
  def login(username, password)

    cpassword = password.crypt(RadianAccount.salt)
    password = nil
    
    token = nil

    account.each do |current|

      # check encrypted passwords
      if current.password === cpassword

        # generate token
        token = SecureRandom.uuid

        # new session
        new_session = RedianSession.new(token)
        session.push(new_session)

        # add to account
        current.session[token] = new_session
        
        break;
        
      end
      
    end
      
    # return token or nil on failed login
    token
    
  end

  # do logout of server
  def logout(token)

    success = false

    # iterate to find session with token
    session.each do |current|
      
      if current.token == token

        session.delete(current)
        success = true
        
        break
        
      end
      
    end
    
    # iterate to find account with token
    account.each do |current|
      
      if current.session.has_key? token

        current.session.delete(token)
        
        break
        
      end
      
    end

    # return true if session found with token
    success
  end

  # add account
  def add_account(username, token, account_username, account_password)

    # TODO:JK: implement me
    
  rescue => err
    false
  end

  # query account
  def query_account(username, token, account_uuid, account_attribute, value)
    success = false

    # TODO:JK: implement me
    
    success
  end
end
