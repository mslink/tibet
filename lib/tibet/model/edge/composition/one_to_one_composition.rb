
module Tibet

  class OneToOneComposition < OneToOneAssociation

    def self.kind
      :composite
    end

    def kind
      :composite
    end

    def composition?
      true
    end

    def composite?
      true
    end

  end

end