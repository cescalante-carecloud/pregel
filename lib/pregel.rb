require File.expand_path("../pregel/vertex.rb", __FILE__)
require File.expand_path("../pregel/worker.rb", __FILE__)
require File.expand_path("../pregel/coordinator.rb", __FILE__)

require 'singleton'

class PostOffice
  include Singleton

  def initialize
    @mailboxes = Hash.new
    @mutex = Mutex.new
  end

  def deliver(to, msg)
    @mutex.synchronize do
      if @mailboxes[to]
        @mailboxes[to].push msg
      else
        @mailboxes[to] = [msg]
      end
    end
  end

  def read(box)
    @mutex.synchronize do
      @mailboxes.delete(box) || []
    end
  end
end
