
module Tibet

  class OneToManyCompositionRefinement < OneToManyAssociationRefinement

    def source_class
      Composition
    end

    def target_class
      OneToManyComposition
    end

  end

end