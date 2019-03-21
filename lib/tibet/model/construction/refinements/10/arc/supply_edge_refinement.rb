
module Tibet

  class SupplyEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = SupplyEdge.new(arc, source_node, target_node)
      end

    end

  end

end