
module Tibet

  class OneToOneAggregationRefinement < OneToOneAssociationRefinement

    def source_class
      Aggregation
    end

    def target_class
      OneToOneAggregation
    end

  end

end