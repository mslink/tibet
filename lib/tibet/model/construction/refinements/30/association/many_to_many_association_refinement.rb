
module Tibet

  class ManyToManyAssociationRefinement < ElementRefinement

    def source_class
      Association
    end

    def target_class
      ManyToManyAssociation
    end

    def match(edge)

      return unless edge.instance_of?(source_class)

      source_multiplicity = edge.source_end.literal_multiplicity
      target_multiplicity = edge.target_end.literal_multiplicity

      multiplicity_set = [:one_or_more, :zero_or_more]
      cartesian = multiplicity_set.product(multiplicity_set)

      if cartesian.include?([source_multiplicity, target_multiplicity])
        @result = target_class.build_from(edge)
      end

    end

  end

end