
module Tibet

  module DerivedTypeSupport

    include MarkerSupport

    attr_reader :occurrences

    def initialize(name, occurrences)
      super(nil) if defined?(super)

      unless occurrences.kind_of?(Array)
        fail "-- error: illegal element deviation @#{name}"
      end

      @name = name
      @occurrences = occurrences
    end

    def qualified_id
      object_id
    end

    def name
      @name
    end

    # contract #MarkerSupport
    # note or delegate to occurrences
    def annotations
      @occurrences.map(&:annotations).flatten
    end

  end

end