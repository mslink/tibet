
module Tibet

  class Graph

    attr_reader :vertices,
                :arcs

    def initialize
      @vertices = []
      @arcs = []
    end

    def add_vertex(namespace, xml_vertex)
      vertices << Vertex.new(namespace, xml_vertex)
    end

    def add_arc(namespace, xml_arc)
      arcs << Arc.new(namespace, xml_arc)
    end

    def add_derived_arc(derived_arc)
      arcs << derived_arc
    end

    def statistics
      "-- stats: graph #{self} contains #{vertices.count} vertices and #{arcs.count} arcs"
    end

  end

end