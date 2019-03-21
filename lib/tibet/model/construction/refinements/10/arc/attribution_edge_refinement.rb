
module Tibet

  class AttributionEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = AttributionEdge.new(arc, source_node, target_node)
      end

    end

  end

end