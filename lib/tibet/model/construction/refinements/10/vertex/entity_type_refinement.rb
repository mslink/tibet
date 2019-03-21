
module Tibet

  class EntityTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = EntityType.new(vertex)
      end

    end

  end

end