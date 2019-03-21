
module Tibet

  class QueryTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = QueryType.new(vertex)
      end

    end

  end

end