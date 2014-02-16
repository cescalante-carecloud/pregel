require File.expand_path("../../lib/pregel.rb", __FILE__)
include Pregel

class PageRankVertex < Vertex
  def compute
    if superstep >= 1
      sum = messages.inject(0) {|total,msg| total += msg; total }
      @value = (0.15 / 3) + 0.85 * sum
    end

    if superstep < 30
      deliver_to_all_neighbors(@value / neighbors.size)
    else
      halt
    end
  end
end