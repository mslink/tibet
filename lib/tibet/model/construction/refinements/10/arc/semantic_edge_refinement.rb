
module Tibet

  class SemanticEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = SemanticEdge.new(arc, source_node, target_node)
      end

    end

  end

end