require File.expand_path("../../lib/pregel.rb", __FILE__)

include Pregel

class AddVertex < Vertex
  def compute
    @value += 1
    halt if @value >= 5
  end
end