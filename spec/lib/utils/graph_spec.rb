require 'rails_helper'
require 'utils/graph'

describe Graph do
  let(:graph) { Graph.new }

  describe '#include_object?' do
    context "when object class isn't Graph::Node -->" do
      let(:object) { "object" }

      context "when inludes the object" do
        before { graph.add_node(object) }

        it "returns true" do
          expect(graph.include_object?(object)).to be_truthy
        end
      end

      context "when doesn't includes the object" do
        it "returns false" do
          expect(graph.include_object?(object)).to be_falsey
        end
      end
    end

    context "when object class is Graph::Node -->" do
      let(:object) { Graph::Node.new("object") }

      context "when inludes the object" do
        before { graph.add_node(object) }

        it "returns true" do
          expect(graph.include_object?(object)).to be_truthy
        end
      end

      context "when doesn't includes the object" do
        it "returns false" do
          expect(graph.include_object?(object)).to be_falsey
        end
      end
    end
  end


  describe '#add_edge' do
    context "when adding node objects -->" do
      let(:object_1) { Graph::Node.new("object_1") }
      let(:object_2) { Graph::Node.new("object_2") }

      context "when node objects already exist" do
        before do
          @node_1 = graph.add_node(object_1)
          @node_2 = graph.add_node(object_2)
          graph.add_edge(@node_1, @node_2)
        end

        it "must include the edge" do
          expect(@node_1.adjacents.include? @node_2).to be_truthy
          expect(@node_2.adjacents.include? @node_1).to be_truthy
        end
      end

      context "when node objects doesn't exists already" do
        before { graph.add_edge(object_1, object_2) }

        it "must include the edge" do
          expect(object_1.adjacents.include? object_2).to be_truthy
          expect(object_2.adjacents.include? object_1).to be_truthy
        end
      end
    end

    context "when adding objects that aren't nodes" do
      let(:object_1) { "object_1" }
      let(:object_2) { "object_2" }

      before do
        graph.add_edge(object_1, object_2)
        @node_1 = graph.get_node(object_1)
        @node_2 = graph.get_node(object_2)
      end

      it "must include the edge" do
        expect(@node_1.adjacents.include? @node_2).to be_truthy
        expect(@node_2.adjacents.include? @node_1).to be_truthy
      end
    end
  end

  describe '#connected_components' do
    let(:object_1) { "object_1" }
    let(:object_2) { "object_2" }
    let(:object_3) { "object_3" }
    let(:object_4) { "object_4" }
    let(:object_5) { "object_5" }
    let(:connected_components) { graph.connected_components }

    before do
      graph.add_edge(object_1, object_2)
      graph.add_edge(object_1, object_3)
      graph.add_edge(object_4, object_5)
    end

    it "returns the right number of connected components" do
      expect(connected_components.count).to eq(2)
    end

    it "identifies the connected components" do
      expect(connected_components.first).to eq([object_1, object_2, object_3])
      expect(connected_components.last).to eq([object_4, object_5])
    end
  end
end
