
module Tibet

  class AggregationRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = Aggregation.new(arc, source_node, target_node)
      end

    end

  end

end