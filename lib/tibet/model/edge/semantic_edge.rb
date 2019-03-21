
module Tibet

  class SemanticEdge < Edge

    def semantic?
      true
    end

    def build?
      modifier(build_pattern)
    end

    def query?
      modifier(query_pattern)
    end

    def ___type_alternative?
      modifier(___type_alternative_pattern)
    end

    def xor?
      modifier(xor_pattern)
    end

    def or?
      modifier(xor_pattern)
    end

    private

    # extract
    # pull
    def modifier(pattern)
      center_annotations.detect {|c| c =~ pattern}
    end

    def build_pattern
      /\{build\}/
    end

    def query_pattern
      /\{query\}/
    end

    def ___type_alternative_pattern
      /\{alternative\}/
    end

    def xor_pattern
      /\{xor\}/
    end

    def or_pattern
      /\{or\}/
    end

  end

end