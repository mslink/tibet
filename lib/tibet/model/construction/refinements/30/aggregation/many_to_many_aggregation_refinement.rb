
module Tibet

  class ManyToManyAggregationRefinement < ManyToManyAssociationRefinement

    def source_class
      Aggregation
    end

    def target_class
      ManyToManyAggregation
    end

  end

end