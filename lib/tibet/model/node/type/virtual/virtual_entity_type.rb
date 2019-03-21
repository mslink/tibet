
module Tibet

  class VirtualEntityType < EntityType

    attr_reader :name

    def initialize(name)
      super

      @name = name
    end

    # contract #MarkerSupport
    def annotations
      []
    end

  end

end