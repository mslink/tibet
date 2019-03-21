
module Tibet

  class ManyToOneAggregation < ManyToOneAssociation

    def self.kind
      :shared
    end

    def kind
      :shared
    end

    def aggregation?
      true
    end

    def shared?
      true
    end

  end

end