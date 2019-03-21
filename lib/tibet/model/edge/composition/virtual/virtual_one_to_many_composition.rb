
module Tibet

  class VirtualOneToManyComposition < OneToManyComposition

    include VirtualEdgeSupport

    # check multiplicities

    def source_multiplicity
      0
    end

    def target_multiplicity
      :*
    end

  end

end