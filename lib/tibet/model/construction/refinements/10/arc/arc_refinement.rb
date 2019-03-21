
module Tibet

  class ArcRefinement < ElementRefinement

    attr_reader :arc

    def match(arc)
      @arc = arc
    end

    def source_node
      model.find_node_by_id(arc.qualified_source_id)
    end

    def target_node
      model.find_node_by_id(arc.qualified_target_id)
    end

    def source_arrow
      arc.source_arrow
    end

    def target_arrow
      arc.target_arrow
    end

    def style
      arc.style
    end

    # clony, see VertexRefinement
    def valid?
      id_infix = self.class.to_s.underscore
                   .split(/_/)
                   .reject { |e| e.eql?('refinement') || e.eql?('edge') }
                   .join('_')
                   .gsub('tibet/', '')

      id = "check_#{id_infix}_edge".to_sym
      SyntaxChecker.send(id, self)
    end

  end

end