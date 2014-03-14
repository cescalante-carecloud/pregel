require File.expand_path("../../models/PageRankVertex.rb", __FILE__)
require File.expand_path("../../models/CSVPageRankEditor.rb", __FILE__)


describe PageRankVertex do
  it 'should calculate PageRank of a circular graph' do
    circle = CSVPageRankEditor.new("data/circle.csv")
    graph = []
    circle.graph.each do |item|
      graph.push(PageRankVertex.new(item[0], item[1], *item[2]))
    end

    c = Coordinator.new(graph)
    c.run

    c.workers.each do |w|
      w.vertices.each do |v|
        (v.value * 100).to_i.should == 33
        puts v.id.to_s + "\t\t" + v.value.to_s + "\n"
      end
    end  
  end
  
  it 'should calculate PageRank of arbitrary graph' do
    arbitrary = CSVPageRankEditor.new("data/arbitrary.csv")
    graph = []
    arbitrary.graph.each do |item|
      graph.push(PageRankVertex.new(item[0], item[1], *item[2]))
    end

    c = Coordinator.new(graph)
    c.run

    c.workers.each do |w|
      (w.vertices.find {|v| v.id == 1}.value * 100).ceil.to_i.should == 19
      (w.vertices.find {|v| v.id == 2}.value * 100).ceil.to_i.should == 13
      (w.vertices.find {|v| v.id == 3}.value * 100).to_i.should == 68
    end
  end
end