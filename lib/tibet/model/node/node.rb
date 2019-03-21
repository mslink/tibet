
module Tibet

  class Node < ModelElement

    include NodePredicateSupport

    attr_reader :in_edges,  # inbound edges
                :out_edges, # outbound edges
                :depth

    def initialize
      super()

      @in_edges  = []
      @out_edges = []

      @depth = 0
    end

    # todo apply Property-By-Regular-Expression-With-Detect pattern globally
    def name
      vertex.annotations.detect {|candidate| candidate =~ name_pattern} || super
    end

    def qualified_id
      vertex.qualified_id
    end

    def cartesian_y
      vertex.cartesian_y
    end

    def add_in_edge(edge)
      in_edges << edge
    end

    def add_out_edge(edge)
      out_edges << edge
    end

    # inbound / outbound edges
    def in_out_edges
      in_edges + out_edges
    end

    def propagate_depth(depth = 0)
    end

    private

    def name_pattern
      /^[A-Z][A-Za-z0-9]*$/
    end

  end

end