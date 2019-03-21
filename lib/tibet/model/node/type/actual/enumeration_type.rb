
module Tibet

  class EnumerationType < EntityType

    def entity?
      false
    end

    def enumeration?
      true
    end

    def enumerate?
      true
    end

  end

end