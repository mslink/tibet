
module Tibet

  class OneToOneAssociation < Association

    def source_required
      source_end.literal_multiplicity.eql?(:one)
    end

    def target_required
      target_end.literal_multiplicity.eql?(:one)
    end

    def one_to_one?
      true
    end

  end

end