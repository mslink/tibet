
module Tibet

  class ExclusionConstraint < SpecificConstraint

    def exclusion?
      true
    end

    def values
      content.match(/^\{(.*)\}$/)
      $1.split(',').map(&:strip)
    end

  end

end