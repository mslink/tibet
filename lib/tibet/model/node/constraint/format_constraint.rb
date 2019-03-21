
module Tibet

# todo clear usage of regular expression anchors (\A, \Z vs. ^, $ in JavaScript and Ruby)

  class FormatConstraint < SpecificConstraint

    def format?
      true
    end

    def rule
      content
    end

  end

end