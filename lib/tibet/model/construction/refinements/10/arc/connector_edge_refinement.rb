
module Tibet

  class ConnectorEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = ConnectorEdge.new(arc, source_node, target_node)
      end

    end

  end

end