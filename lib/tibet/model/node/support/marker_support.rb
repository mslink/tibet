
module Tibet

  module MarkerSupport

    def marker?(spec)
      _marker?(annotations, spec)
    end

    def markers?(spec)
      _markers?(annotations, spec)
    end

    # clone to #EdgeModifierSupport
    # detects single marker occurrence
    # spec is a lambda function
    def _marker?(annotations, spec)
      match = annotations.detect{|candidate| spec[candidate]}
      spec[match] if match
    end

    # selects multiple occurrences
    # spec is a lambda function
    def _markers?(annotations, spec)
      annotations.select{|candidate| spec[candidate]}.map{|candidate| spec[candidate]}
    end
    # /clone

  end

end