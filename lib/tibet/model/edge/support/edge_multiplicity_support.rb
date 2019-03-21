
module Tibet

  module EdgeMultiplicitySupport

    # todo
    # derive this as class Concept proxying the
    # edge/endpoint multiplicity annotations (no state building, on the fly)

    def source_multiplicity
      multiplicity(arc.source_annotations) || default_source_multiplicity
    end

    def target_multiplicity
      multiplicity(arc.target_annotations) || default_target_multiplicity
    end

    def default_source_multiplicity
      source_functional ? [1,1] : [0,1]
    end

    def default_target_multiplicity
      target_functional ? [1,1] : [0,1]
    end

    def normalize_multiplicity(tuple)
      tuple.map do |value|
        # for parsed asterisks from model
        if value.to_s.eql?('*')
          # check numeric representation of '*'
          256 || Float::INFINITY
        else
          Integer(value)
        end
      end
    end

    def ___default_multiplicity
      [0,1]
    end

    # todo do not use globals here, switch to #captures (groups)
    def multiplicity(annotations)
      # modality and cardinality available
      return normalize_multiplicity([$1,$2]) if annotations.detect { |candidate| candidate =~ multiplicity_pattern }

      # check vice-versa?
      # only cardinality available, modality is 0 for default
      return normalize_multiplicity([0,$1]) if annotations.detect { |candidate| candidate =~ cardinality_pattern }

      # nothing given
      # default_multiplicity
    end

    def multiplicity_pattern
      /^(\d+)-(\d+|\*)$/
    end

    def cardinality_pattern
      /^(\d+|\*)$/
    end

  end

end