
module Tibet

  class RestrictionEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = RestrictionEdge.new(arc, source_node, target_node)
      end

    end

  end

end