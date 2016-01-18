require 'pty'

class Redian::ShellSession < Object

  REDIAN_SHELL_SESSION_DEFAULT_TITLE = "redian-shell"
  REDIAN_SHELL_SESSION_DEFAULT_HOSTNAME = "localhost"

  attr_accessor :master, :slave,
                :process_state,
                :title

  def initialize(title)

    @title = title
    
    # pseudo TTY
    @master, @slave = PTY.open

    # process is running
    @process_state = 'R'

  end

  def master_read_xml()

    # TODO:JK: implement me
    
  end

  def stdin_write_xml()

    # TODO:JK: implement me

  end
  
end
