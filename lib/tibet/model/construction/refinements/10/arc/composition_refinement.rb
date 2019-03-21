
module Tibet

  class CompositionRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = Composition.new(arc, source_node, target_node)
      end

    end

  end

end