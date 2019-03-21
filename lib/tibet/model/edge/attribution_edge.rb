
module Tibet

  class AttributionEdge < Edge

    def attribution?
      true
    end

    # check
    # prevents transformation to enumeration
    # (see #EnumerationAttribute2EnumerationTypeRefinement)
    def forced?
      arc.source_arrow.eql?('dash')
    end

    def default_multiplicity
      [0,1]
    end

  end

end