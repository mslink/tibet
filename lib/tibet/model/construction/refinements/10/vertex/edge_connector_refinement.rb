
module Tibet

  class EdgeConnectorRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = EdgeConnector.new(vertex)
      end

    end

  end

end