
module Tibet

  class EdgeConnectorOnDerivedArcRefinement < ElementRefinement

    attr_reader :graph

    def initialize(graph, model)
      super(model)

      @graph = graph
    end

    def process

      model.edge_connectors.each do |node|

        unless check_semantic(node)
          # fail "-- error around #{node}: no semantic edge found".red
          puts "-- warning around #{node}: no semantic edge found".red

          # next
        end

        next if node.volatiles[:caught]

        # detect all neighbours of edge connector node
        neighbours = node.neighbours
        neighbours.each { |n| n.volatiles[:caught] = true }

        begin

          # find source part (beginning of arc)
          source_part = neighbours
                          .detect(&:source_contact_point?)
                          .in_edges
                          .select(&:connector_edge?)
                          .first.arc

          # find target part (ending of arc)
          target_part = neighbours
                          .detect(&:target_contact_point?)
                          .out_edges
                          .select(&:connector_edge?)
                          .first.arc

        rescue NoMethodError
          puts "-- error: check connector edges around #{neighbours.map(&:name)}".red

          # re-raise last exception
          raise
        end

        arc = DerivedArc.new(source_part, target_part, [])

        arc.edge_connectors = neighbours

        graph.add_derived_arc(arc)
      end

    end

    def check_semantic(node)
      node.in_out_edges.any?(&:semantic?)
    end

  end

end