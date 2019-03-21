
module Tibet

  class OneToOneCompositionRefinement < OneToOneAssociationRefinement

    def source_class
      Composition
    end

    def target_class
      OneToOneComposition
    end

  end

end