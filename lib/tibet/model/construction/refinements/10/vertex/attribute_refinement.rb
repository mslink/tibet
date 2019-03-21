
module Tibet

  class AttributeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = Attribute.new(vertex)
      end

    end

  end

end