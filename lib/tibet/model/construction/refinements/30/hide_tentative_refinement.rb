
module Tibet

  class HideTentativeRefinement < ElementRefinement

    def match(edge)

      return unless edge.edge?
      return unless edge.tentative

      Report.info "#{edge} is marked as tentative and will be hidden"

      true
    end

    def do_not_add
      true
    end

  end

end