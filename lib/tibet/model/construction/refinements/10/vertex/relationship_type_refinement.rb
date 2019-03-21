
module Tibet

  class RelationshipTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = RelationshipType.new(vertex)
      end

    end

  end

end