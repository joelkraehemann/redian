$LOAD_PATH << '..'
$LOAD_PATH << '.'

require_relative '../redian'

require "rubygems"
require "event_aggregator"

class Redian::StdStringIO < StringIO

  attr_accessor :non_blocking
  
  def initialize(non_blocking)

    @non_blocking = non_blocking
    
  end

  def getbyte

    # TODO:JK: implement me
    
  end
  
  def getc

    # TODO:JK: implement me
    
  end

  def gets

    # TODO:JK: implement me
    
  end
  
  def putc

    # TODO:JK: implement me
    
  end
  
  # overriding read and adding pre-/post-event hooks
  def read(length, buffer = nil)

    # pre-event hook, non-async
    EventAggregator::Message.new("read-event", [self, length, buffer], false).publish

    if buffer == nil

      buffer = super(length)

    else

      super(length, buffer)
      
    end
    
    # post-event hook, non-async
    EventAggregator::Message.new("read-event-post", [self, length, buffer], false).publish

    buffer
    
  end

  def readlines

    # TODO:JK: implement me

  end
  
  def string

    # TODO:JK: implement me
    
  end
  
  # overriding write and adding pre-/post-event hooks
  def write(str)

    length = -1

    # pre-event hook, non-async
    EventAggregator::Message.new("write-event", [self, str, length], @non_blocking).publish

    if @non_blocking == true

      # TODO:JK: this is very slow
      Thread.new do

        length = super(str)

      end
      
    else
      
      length = super(str)

    end
    
    # post-event hook, non-async
    EventAggregator::Message.new("write-event-post", [self, str, length], @non_blocking).publish

    length
    
  end

  def string=

    # TODO:JK: implement me
    
  end
  
  def ungetbyte

    # TODO:JK: implement me
    
  end
  
  def ungetc

    # TODO:JK: implement me
    
  end
  
  def truncate

    # TODO:JK: implement me
    
  end
  
end
