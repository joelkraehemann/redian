$LOAD_PATH << '..'
$LOAD_PATH << '.'

require_relative '../redian'
require_relative 'redian_job_control'

require 'pty'

class Redian::ShellSession < Object

  include Redian::JobControl
  
  SHELL_SESSION_DEFAULT_TITLE = "redian-shell"
  SHELL_SESSION_DEFAULT_SPAWN_PROGRAM = "./redian_build_server.rb"
  
  attr_accessor :title, :spawn_program,
                :master, :slave,
                :in, :out, :err,
                :lines, :cols,
                :history,
                :process_state, :child_pid

  def initialize(title, spawn_program)

    @title = title
    @spawn_program = spawn_program
    
    # pseudo TTY
    @master, @slave = PTY.open

    # process is running
    @process_state = :REDIAN_SHELL_RUNNING

    # pseudo files in, out, err
    @in = Redian::StdStringIO.new(false)
    @out = Redian::StdStringIO.new(false)
    @err = Redian::StdStringIO.new(true)

    # pseudo file history
    @lines = 24
    @cols = 80
    
    @history = StringIO.new
    
    # spawn process
    @child_pid = spawn(@spawn_program, :in => @in, :out => @out, :err => @err)
    
  end

  def self.with_defaults

    new(SHELL_SESSION_DEFAULT_TITLE, SHELL_SESSION_DEFAULT_SPAWN_PROGRAM)
    
  end

  def set_allocation(lines, cols)

    @lines =
      ENV["LINES"] = lines

    @cols =
      ENV["COLS"] = cols
    
  end
  
  def master_readline()

    node = nil
    
    # TODO:JK: implement me

    node
    
  end

  def send_key(*key)

    # TODO:JK: implement me

    nil
    
  end

end
