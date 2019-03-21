
module Tibet

  class GraphBuilder

    attr_reader :parsers,
                :graph

    def initialize(parsers)
      @parsers = parsers

      @graph = Graph.new
    end

    def perform
      parsers.each { |parser| read_elements(parser) }
      graph
    end

    private

    # bootstrap initial graph
    def read_elements(parser)
      parser.scan_vertices.each do |xml_vertex|
        graph.add_vertex(parser.namespace, xml_vertex)
      end

      parser.scan_arcs.each do |xml_arc|
        graph.add_arc(parser.namespace, xml_arc)
      end
    end

  end

end