$LOAD_PATH << '..'
$LOAD_PATH << '.'

require_relative "../redian"

require 'logger'

class Redian::XssFilter < Object
  
  LOGGER_FILENAME = "/dev/stdout"
  
  DEFAULT_ALLOWED_PATTERN = /^[a-xA-X][a-xA-X\-]*/
  DEFAULT_ALLOWED_STRING_PATTERN = /(?!(\#\{)(.*)(\}))/
  
  @@logger = Logger.new(LOGGER_FILENAME)

  attr_reader :allowed_pattern, :allowed_string_pattern

  class << self

    @@logger.progname = "redian-server"

  end

  # default constructor
  def initialize(allowed_pattern, allowed_string_pattern)

    @allowed_pattern = allowed_pattern
    @allowed_string_pattern = allowed_string_pattern
    
  end

  # constructor with defaults
  def self.with_defaults

    new(DEFAULT_ALLOWED_PATTERN, DEFAULT_ALLOWED_STRING_PATTERN)
    
  end

  # checks for XSS
  def check(*args)

    success = true

    if args != nil
      
      args.each do |current|

        case current.instance_of?
        when Hash

          # check hash for XSS
          success = check(current.keys)
          
          if success == false

            break

          end

          success = check(current.values)

          if success == false

            break

          end

        when Array

          # check array for XSS
          success = check(current)

          if success == false

            break

          end
          
        when String

          # check string for XSS
          success = @allowed_string_pattern.match(current)

          if success == false

            break

          end

        when Symbol

          # check symbol for XSS
          success = @allowed_pattern.match(current.id2name)

          if success == false

            break

          end
          
        else
          success = false
        end
        
      end

    end

    # retval or propagate exception
    if success == true

      true
      
    else

      raise ArgumentError.new("XSS detected or not allowed type")
      
    end
    
  end
  
end
