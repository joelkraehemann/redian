$LOAD_PATH << '..'

require "redian"

class Redian::Session

  include Redian
  
  attr_accessor :username, :token,
                :last_hit
  
end
