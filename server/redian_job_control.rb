$LOAD_PATH << '..'
$LOAD_PATH << '.'

require_relative '../redian'

module Redian::JobControl
  
  :REDIAN_SHELL_RUNNING
  :REDIAN_SHELL_UNINTERRUPTIBLE_SLEEP
  :REDIAN_SHELL_INTERRUPTIBLE_SLEEP
  :REDIAN_SHELL_DEFUNCT
  :REDIAN_SHELL_STOPPED
  
end
