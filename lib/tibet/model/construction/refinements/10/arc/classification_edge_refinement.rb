
module Tibet

  class ClassificationEdgeRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = ClassificationEdge.new(arc, source_node, target_node)
      end

    end

  end

end