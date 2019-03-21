
module Tibet

  class OneToOneAssociationRefinement < ElementRefinement

    def source_class
      Association
    end

    def target_class
      OneToOneAssociation
    end

    def match(edge)

      return unless edge.instance_of?(source_class)

      source_multiplicity = edge.source_end.literal_multiplicity
      target_multiplicity = edge.target_end.literal_multiplicity

      multiplicity_set = [:one, :zero_or_one]
      cartesian = multiplicity_set.product(multiplicity_set)

      if cartesian.include?([source_multiplicity, target_multiplicity])
        @result = target_class.build_from(edge)
      end

    end

  end

end