#parses .csv relationship file and node file and produces an updated node file

DATAPATH = "./data/"
OUTPUTPATH = "./output/"

class CSVPageRankEditor
  attr_reader :graph

  def initialize(relsfile)
    @rels_reader = File.new(relsfile, "r")
    @graph = []
    populate_graph  
  end

  def populate_graph
    header = @rels_reader.gets
    mini = []
    id = -1
    @rels_reader.each do |line|
      data = line.split('|')
      if data[0] != id
        @graph.push(mini) unless mini == []
        mini = [data[0].to_i, 1, [data[1].to_i]]
        id = data[0]
      else
        mini[2].push(data[1].to_i)
      end
    end
    @graph.push(mini) unless mini == []
  end

  def write(hash_o_values, nodesfile)
    @node_reader = File.new(DATAPATH + nodesfile, "r")
    @node_writer = File.new(OUTPUTPATH + nodesfile, "w+")
    
    data = @node_reader.gets.split('|', 2)
    @node_writer.puts(data[0] + "|pagerank|" + data[1])

    @node_reader.each do |line|
      data = line.split('|', 2)
      new_line = data[0] + "|" + hash_o_values[data[0].to_i].to_s + "|" + data[1]
      @node_writer.puts(new_line)
    end
  end
end