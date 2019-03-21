
module Tibet

  class ClassTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = ClassType.new(vertex)
      end

    end

  end

end