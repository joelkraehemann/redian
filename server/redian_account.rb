class Redian::Account

  @@salt = nil
  
  attr_accessor :username, :password,
                :firstname, :surname,
                :email, :uuid,
                :security_context, :session

  class << self

    @@salt = Redian::Account.generate_salt
    
  end
  
  def initialize(username = nil, password = nil, firstname = nil, surname = nil, email = nil, uuid)

    @username = username
    @password = password
    
    @firstname = firstname
    @surname = surname
    @email = email

    @uuid = uuid
    
    @security_context = Array.new
    @session = Hash.new
  end

  def self.with_defaults

    new(:uuid => SecureRandom.uuid)
    
  end

  def Redian::Account.generate_salt

    # TODO:JK: implement salt setup

    nil
    
  end
  
end
