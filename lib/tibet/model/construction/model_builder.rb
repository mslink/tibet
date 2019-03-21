
module Tibet

  class ModelBuilder

    attr_reader :controller,
                :graph,

                :model

    # check structure: controller is two levels above
    def initialize(controller, graph)
      @controller = controller
      @graph = graph

      @model = TibetModelView.new(Model.new)
    end

    def perform

      # streamline
      return model unless graph

      # check for empty concrete types having no attributes resp. associations

      # graph_based_transformations
      # iterate = false
      # (use iteration, if, for example, representation must at first be
      # converted to connector edges / edge connectors and from there to
      # derived arcs)
      # loop for dependency resolution
      # check this feature is not fully implemented yet *1
      # loop do

      gbb = GraphBasedBuilder.new(graph, model)
      gbb.refine_vertices
      gbb.refine_arcs
      model.validate!

      EdgeConnectorOnDerivedArcRefinement.new(graph, model).process
      model.validate!

      # refine arcs again to fetch derived arcs
      gbb.refine_arcs
      model.validate!

      # select references *1
      # @model.type_nodes.select(&:reference)

      # break unless iterate
      # end

      VisualPositionCalculationRefinement.new(model).process
      model.validate!

      # order_20_refinements
      # @model.validate!

      order_30_refinements
      model.validate!

      order_40_refinements
      model.validate!

      model.finish!
      model.validate!

      model
    end

    def graph_based_transformations
      # pull logic here
    end

    private

    def order_20_refinements
      # implement
    end

    ####

    def order_30_refinements
      refine_edges
      refine_nodes
    end

    def edge_refinements
      [
        HideTentativeRefinement,

        OneToOneAssociationRefinement,
        OneToManyAssociationRefinement,
        ManyToOneAssociationRefinement,
        ManyToManyAssociationRefinement,

        OneToOneAggregationRefinement,
        OneToManyAggregationRefinement,
        ManyToOneAggregationRefinement,
        ManyToManyAggregationRefinement,

        OneToOneCompositionRefinement,
        OneToManyCompositionRefinement

      ]
        .map { |refinement_class| refinement_class.new(model) }
    end

    def refine_edges
      buffer = []

      model.edges.each do |edge|
        refinement = edge_refinements.detect { |refinement| refinement.match(edge) }

        if refinement
          edge.hide! unless refinement.do_not_hide
          buffer << refinement
        end

      end

      buffer.each { |refinement| model.add_edge(refinement.result) unless refinement.do_not_add }
    end

    def node_refinements
      [
        # EnumerationAttribute2EnumerationTypeRefinement,
        EnumerationTypeNormalizationRefinement,
        ConstraintSpecializationRefinement
      ]
        .map { |refinement_class| refinement_class.new(model) }
    end

    # caution: external control of hide/write-through/add-node seems to be error prone!
    # refactor
    def refine_nodes

      begin
        buffer = []

        model.nodes.each do |node|
          refinement = node_refinements.detect { |refinement| refinement.match(node) }

          if refinement
            node.hide! unless refinement.do_not_hide

            # write through for immediate model manipulation
            # if refinement.write_through
            model.add_node(refinement.result) unless refinement.do_not_add

            # fail 'modification'
            # else
            #   buffer << refinement
            # end
          end
        end

      rescue RuntimeError => e
        if e.message.eql?('modification')
          puts '-- info: repeating #refine_nodes'

          buffer.each { |refinement| model.add_node(refinement.result) unless refinement.do_not_add }
          retry
        end

        abort
      end

    end

    ####

    def order_40_refinements
      TypeUnificationRefinement.new(model).process
      M2NBiPolymorphicJoinModelDecompositionRefinement.new(model).process
      TransitiveAssociationDetectionRefinement.new(model).process
      PolymorphicAssociationDetectionRefinement.new(model).process
      ReflexiveAssociationDetectionRefinement.new(model).process
    end

  end

end