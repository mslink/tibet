
module Tibet

  class VertexRefinement < ElementRefinement

    attr_reader :vertex

    def match(vertex)
      @vertex = vertex
    end

    # clony, see ArcRefinement
    def valid?
      id_infix = self.class.to_s.underscore
                   .split(/_/)
                   .reject {|e| e.eql?('refinement')}
                   .join('_')
                   .gsub('tibet/', '')

      id = "check_#{id_infix}_node".to_sym
      SyntaxChecker.send(id, self)
    end

  end

end