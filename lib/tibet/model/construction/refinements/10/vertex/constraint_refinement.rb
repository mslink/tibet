
module Tibet

  class ConstraintRefinement < VertexRefinement

    def match(vertex)
      super

      if valid?
        @result = Constraint.new(vertex)
      end

    end

  end

end