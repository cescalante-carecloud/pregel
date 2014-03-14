#parses .csv relationship file and node file and produces an updated node file

#DATAPATH = "./data/"
#OUTPUTPATH = "./output/"

class CSVPageRankEditor
  attr_reader :graph

  def initialize(relsfile)
    puts relsfile
    @rels_reader = File.new(DATAPATH+relsfile, "r")
    @graph = []
    populate_graph  
  end

  def populate_graph
    header = @rels_reader.gets #tossing this line
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
    node_reader = File.open(DATAPATH + nodesfile, "r")
    node_writer = File.new(OUTPUTPATH + "temp_" + nodesfile, "w")
    firstline = node_reader.gets
    overwrite = true
    overwrite = false unless firstline.match('pagerank') != nil
    puts overwrite

    data = [firstline.split('|',3)[0], firstline.split('|',3)[2]] if overwrite
    data = firstline.split('|', 2) unless overwrite
    node_writer.puts(data[0] + "|pagerank|" + data[1])
    node_reader.each do |line|
      data = [line.split('|',3)[0], line.split('|',3)[2]] if overwrite
      data = line.split('|', 2) unless overwrite
      node_writer.puts(data[0] + "|" + hash_o_values[data[0].to_i].to_s + "|" + data[1])
    end
    node_reader.close
    node_writer.close
    cleanup(nodesfile)
  end

  def cleanup(nodesfile)
    node_reader = File.open(OUTPUTPATH + "temp_" + nodesfile, "r")
    node_writer = File.new(OUTPUTPATH + nodesfile, "w+")

    node_reader.each do |line|
      node_writer.puts(line)
    end
    node_reader.close
    node_writer.close
    File.delete(OUTPUTPATH + "temp_" + nodesfile)
  end

end