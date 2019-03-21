
module Tibet

# note respect #TibetModelView

  class Model < ModelElement

    attr_reader :nodes,
                :edges

    def initialize
      super

      @nodes = []
      @edges = []
    end

    def add_node(node)
      fail '-- error: will not add nil or non-node element' unless node || !node.node?

      # puts "-- adding node #{node}"

      nodes << node
    end

    def find_node_by_id(id)
      nodes.detect{|node| node.qualified_id.eql?(id)}
    end

    def add_edge(edge)
      fail '-- error: will not add nil or non-edge element' unless edge || !edge.edge?
      edges << edge
    end

    # todo forward to #ModelValidator
    def validate!
      fail '-- error: nil elements detected' unless nodes.all? && edges.all?

      unless nodes.all?(&:name)
        causer = nodes.detect{|e| !e.name}
        fail "-- error: node without name @#{causer}"
      end
    end

    def finish!
      nodes.each(&:propagate_depth)
    end

    def statistics
      <<-eos

    model #{self} statistics:
    total nodes: #{nodes.count}
    total edges: #{edges.count}
    ----------------------------------------------
    hidden nodes: #{nodes.select(&:hidden?).count}
    hidden edges: #{edges.select(&:hidden?).count}

      eos
    end

  end

end