$LOAD_PATH << '..'

require "redian"

class Redian::SecurityContext

  include Redian
  
  attr_accessor :context, :permission
  
end
