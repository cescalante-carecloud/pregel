DATAPATH = File.expand_path("../output", __FILE__) + '/'
OUTPUTPATH = File.expand_path("../output", __FILE__) + '/'

require File.expand_path("../models/PageRankVertex.rb", __FILE__)
require File.expand_path("../models/CSVPageRankEditor.rb", __FILE__)

rel_input = "user_rels.csv"
node_output = "user_nodes.csv"

parsed = CSVPageRankEditor.new(rel_input)
graph = []
parsed.graph.each do |item|
  graph.push(PageRankVertex.new(item[0], item[1], *item[2]))
end

c = Coordinator.new(graph)
c.run

parsed.write(c.to_h, node_output)