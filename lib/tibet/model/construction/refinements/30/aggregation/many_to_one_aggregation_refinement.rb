
module Tibet

  class ManyToOneAggregationRefinement < ManyToOneAssociationRefinement

    def source_class
      Aggregation
    end

    def target_class
      ManyToOneAggregation
    end

  end

end