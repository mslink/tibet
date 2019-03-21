
module Tibet

  class IntervalConstraint < SpecificConstraint

    def interval?
      true
    end

    def interval
      content.match(/^(\d*)-(\d*)$/)
      [$1,$2].map(&:to_i)
    end

  end

end