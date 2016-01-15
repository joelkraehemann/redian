class RedianAccount

  @@salt = nil
  
  attr_accessor :username, :password,
                :firstname, :surname,
                :email, :uuid,
                :security_context, :session

  def initialize

    @username = nil
    @password = nil
    
    @firstname = nil
    @surname = nil
    @email = nil
    
    @security_context = Array.new
    @session = Hash.new
  end

  def RedianAccount.setup_salt

    # TODO:JK: implement salt setup
    
  end
  
end
