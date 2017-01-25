class Graph
  attr_reader :nodes

  # Graph node.
  class Node
    attr_reader :object, :adjacents

    # Adjacents are the nodes where this node is connected.
    def initialize(object)
      @object = object
      @adjacents = []
    end
  end

  # Can be initialized with an array of objects.
  def initialize(objects = nil)
    @nodes = []
    objects.each { |object| add_node(object) } if objects && !objects.empty?
  end

  # Check if an object is already in the graph.
  def include_object?(object)
    if is_node?(object)
      @nodes.each { |node| return true if node == object }
    else
      @nodes.each { |node| return true if node.object == object }
    end

    false
  end

  # Add a node to the graph. The node is the method return: what the method lose
  # elegancy, he wins in performance, avoiding queries in some methods that use
  # this method.
  def add_node(object)
    if is_node?(object)
      node = object
      @nodes << object
    else
      node = Node.new(object)
      @nodes << node
    end

    node
  end

  # Add a connection between two nodes (if the objects doesn't exists already,
  # they're created automatically). A connection is simetrical: if A is
  # connected to B, B is connected to A.
  def add_edge(object_1, object_2)
    node_1 = check_object(object_1)
    node_2 = check_object(object_2)
    node_1.adjacents << node_2
    node_2.adjacents << node_1
  end

  # Retun the Graph::Node that contains the specified object (or nil if
  # doesn't exists).
  def get_node(object)
    @nodes.each do |node|
      return node if node.object == object
    end
  end

  def connected_components
    visited = []
    connected_components = []
    @nodes.each do |node|
      component = []
      next if visited.include?(node)
      dfs(node, visited, component)
      connected_components << component
    end
    connected_components
  end

    private

    # Depth first search algorithm adapted to get a connected_component from
    # the graph.
    def dfs(node, visited, component = [])
      visited << node
      component << node.object

      node.adjacents.each do |adjacent_node|
        dfs(adjacent_node, visited, component) unless visited.include?(adjacent_node)
      end
    end

    def is_node?(object)
      object.class == Graph::Node
    end

    # Check if the object is already a Graph::Node object and if is part of the
    # graph. Return as result the object in a Graph::Node.
    def check_object(object)
      return add_node(object) unless include_object?(object)
      if is_node?(object)
        object
      else
        get_node(object)
      end
    end
end
