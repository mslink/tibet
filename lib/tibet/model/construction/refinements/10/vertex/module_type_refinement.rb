
module Tibet

  class ModuleTypeRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = ModuleType.new(vertex)
      end

    end

  end

end