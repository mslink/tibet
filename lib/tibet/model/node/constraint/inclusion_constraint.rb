
module Tibet

  class InclusionConstraint < SpecificConstraint

    def inclusion?
      true
    end

    def values
      content.match(/^\{(.*)\}$/)
      $1.split(',').map(&:strip)
    end

  end

end