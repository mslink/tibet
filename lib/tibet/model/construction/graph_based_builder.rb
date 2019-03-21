
module Tibet

  class GraphBasedBuilder

    attr_reader :graph,
                :model

    def initialize(graph, model)
      @graph = graph
      @model = model
    end

    # caution: take care of refinement order

    def vertex_refinements
      [
        ClassTypeRefinement,
        EntityTypeRefinement,
        EnumerationTypeRefinement,
        QueryTypeRefinement,
        ModuleTypeRefinement,
        RelationshipTypeRefinement,
        AttributeRefinement,
        ConstraintRefinement,
        EdgeConnectorRefinement
      ]
        .map {|refinement_class| refinement_class.new(model)}
    end

    def refine_vertices
      graph.vertices.each do |vertex|
        next if vertex.volatiles[:visited]

        refinement = vertex_refinements.detect { |refinement| refinement.match(vertex) }

        if refinement
          model.add_node(refinement.result) unless refinement.do_not_add
          vertex.volatiles[:visited] = true
        else
          Report.info("vertex #{vertex.reveal} could not be matched")
        end

      end
    end

    def arc_refinements
      [
        AssociationRefinement,
        AggregationRefinement,
        CompositionRefinement,

        AttributionEdgeRefinement,
        RestrictionEdgeRefinement,

        ClassificationEdgeRefinement,
        InclusionEdgeRefinement,

        ConnectorEdgeRefinement,
        SemanticEdgeRefinement,

        SupplyEdgeRefinement
      ]
        .map {|refinement_class| refinement_class.new(model)}
    end

    def refine_arcs
      graph.arcs.each do |arc|
        next if arc.volatiles[:visited]

        refinement = arc_refinements.detect { |refinement| refinement.match(arc) }

        if refinement
          model.add_edge(refinement.result) unless refinement.do_not_add
          arc.volatiles[:visited] = true
        else
          Report.info("arc #{arc.reveal} could not be matched")
        end

      end
    end

  end

end