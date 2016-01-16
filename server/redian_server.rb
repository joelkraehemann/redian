require "xmlrpc/server"
require "logger"

class RedianServer < XMLRPC::Server

  REDIAN_LOGGER_FILENAME = "/dev/stdout"
  
  REDIAN_BUILD_HOST = "127.0.0.1"
  REDIAN_BUILD_PORT = 10000
  
  @@logger = Logger.new(REDIAN_LOGGER_FILENAME)
  
  attr_accessor :account, :session
  
  # default constructor
  def initialize(host, port)

    super(host, port)

    @@logger.info("creating new server instance on #{host}:#{port}")
    
    @account = Array.new
    @session = Array.new
    
    # redian login handler
    add_handler("redian.login") do |username, password|

      login(username, password)
      
    end

    # redian logout handler
    add_handler("redian.logout") do |token|

      logout(token)
      
    end

    # redian add account handler
    add_handler("redian.account.add") do |username, token, account_username, account_password|

      add_account(username, token, account_username, account_password)
      
    end

    # redian remove account handler
    add_handler("redian.account.remove") do |username, token, account_uuid|

      remove_account(username, token, account_uuid)
      
    end

    # redian set account attribute handler
    add_handler("redian.account.set_attribute") do |username, token, account_uuid, account_attribute, value|

      set_account_attribute(username, token, account_uuid, account_attribute, value)
      
    end

    # redian get account attribute handler
    add_handler("redian.account.get_attribute") do |username, token, account_uuid, account_attribute|

      get_account_attribute(username, token, account_uuid, account_attribute)
      
    end

    # redian list account handler
    add_handler("redian.account.list") do |username, token, account_uuid|

      list_account(username, token, account_uuid)
      
    end

    # redian set profile attribute handler
    add_handler("redian.profile.set_attribute") do |username, token, account_uuid, account_attribute, value|

      set_profile_attribute(username, token, account_uuid, account_attribute, value)
      
    end

    # redian get profile attribute handler
    add_handler("redian.profile.get_attribute") do |username, token, account_uuid, account_attribute|

      get_profile_attribute(username, token, account_uuid, account_attribute)
      
    end

    # redian list profile handler
    add_handler("redian.profile.list") do |username, token, account_uuid|

      list_profile(username, token, account_uuid)
      
    end

  end

  # with defaults constructor
  def with_defaults
    
    new(REDIAN_BUILD_HOST, REDIAN_BUILD_PORT)
    
  end

  # check access rights
  def authenticate(username, token, context, permission)

    # find session
    found_session = false
    
    @session.each do |current|

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

    @account.each do |current|

      # find username
      if current.username == username

        current.security_context.each |current_context| do

          # find context
          if current_context.context == context

            # check permission
            if current.permission == permission

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

    @account.each do |current|

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
    @session.each do |current|
      
      if current.token == token

        session.delete(current)
        success = true
        
        break
        
      end
      
    end
    
    # iterate to find account with token
    @account.each do |current|
      
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

    security_context = 'redian.account'
    access_permission = 'rw'
    success = false
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me

    success
    
  rescue => err

    @@logger.warn("Exception occured during redian.add_account: #{err}")
    
    false
    
  end

  # add account
  def remove_account(username, token, account_uuid)

    security_context = 'redian.account'
    access_permission = 'rw'
    success = false
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me

    success
    
  rescue => err

    @@logger.warn("Exception occured during redian.add_account: #{err}")
    
    false
    
  end

  # set account attribute
  def set_account_attribute(username, token, account_uuid, account_attribute, value)

    security_context = 'redian.account'
    access_permission = 'rw'
    success = false

    authenticate(username, token, security_context, access_permission)
    
    # TODO:JK: implement me
    
    success

  rescue => err

    @@logger.warn("Exception occured during redian.set_account_attribute: #{err}")
    
    false
      
  end

  # get account attribute
  def get_account_attribute(username, token, account_uuid, account_attribute)

    security_context = 'redian.account'
    access_permission = 'r'
    value = nil
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me
    
    value

  rescue => err

    @@logger.warn("Exception occured during redian.get_account_attribute: #{err}")
    
    false
      
  end

  # list account
  def list_account(username, token, account_uuid)

    security_context = 'redian.account'
    access_permission = 'r'
    value = nil
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me
    
    value

  rescue => err

    @@logger.warn("Exception occured during redian.list_account: #{err}")
    
    false
      
  end

  # set profile attribute
  def set_profile_attribute(username, token, account_uuid, account_attribute, value)

    security_context = 'redian.profile'
    access_permission = 'rw'
    success = false

    authenticate(username, token, security_context, access_permission)
    
    # TODO:JK: implement me
    
    success

  rescue => err

    @@logger.warn("Exception occured during redian.set_profile_attribute: #{err}")
    
    false
      
  end

  # get profile attribute
  def get_profile_attribute(username, token, account_uuid, account_attribute)

    security_context = 'redian.profile'
    access_permission = 'r'
    value = nil
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me
    
    value

  rescue => err

    @@logger.warn("Exception occured during redian.get_profile_attribute: #{err}")
    
    false
      
  end

  # list profile
  def list_profile(username, token, account_uuid, account_attribute)

    security_context = 'redian.profile'
    access_permission = 'r'
    value = nil
    
    authenticate(username, token, security_context, access_permission)

    # TODO:JK: implement me
    
    value

  rescue => err

    @@logger.warn("Exception occured during redian.list_profile: #{err}")
    
    false
      
  end


end
