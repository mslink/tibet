
module Tibet

  class InclusionEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = InclusionEdge.new(arc, source_node, target_node)
      end

    end

  end

end