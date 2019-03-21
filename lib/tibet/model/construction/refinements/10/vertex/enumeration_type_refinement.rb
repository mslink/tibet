
module Tibet

  class EnumerationTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = EnumerationType.new(vertex)
      end

    end

  end

end