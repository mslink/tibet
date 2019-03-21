
module Tibet

  class OneToManyComposition < OneToManyAssociation

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