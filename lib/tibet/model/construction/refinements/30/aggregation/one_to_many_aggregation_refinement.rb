
module Tibet

  class OneToManyAggregationRefinement < OneToManyAssociationRefinement

    def source_class
      Aggregation
    end

    def target_class
      OneToManyAggregation
    end

  end

end