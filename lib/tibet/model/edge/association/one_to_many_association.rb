
module Tibet

  class OneToManyAssociation < Association

    def source_required
      source_end.literal_multiplicity.eql?(:one)
    end

    def target_required
      target_end.literal_multiplicity.eql?(:one_or_more)
    end

    def one_to_many?
      true
    end

  end

end