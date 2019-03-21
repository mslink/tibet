
module Tibet

  class OneToManyAssociationRefinement < ElementRefinement

    def source_class
      Association
    end

    def target_class
      OneToManyAssociation
    end

    def match(edge)

      return unless edge.instance_of?(source_class)

      source_multiplicity = edge.source_end.literal_multiplicity
      target_multiplicity = edge.target_end.literal_multiplicity

      cartesian = [[:one, :one_or_more], [:one, :zero_or_more],
                   [:zero_or_one, :one_or_more], [:zero_or_one,:zero_or_more]]

      if cartesian.include?([source_multiplicity, target_multiplicity])
        @result = target_class.build_from(edge)
      end

    end

  end

end