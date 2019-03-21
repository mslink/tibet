
module Tibet

  class ManyToManyAssociation < Association

    def source_required
      source_end.literal_multiplicity.eql?(:one_or_more)
    end

    def target_required
      target_end.literal_multiplicity.eql?(:one_or_more)
    end

    def many_to_many?
      true
    end

  end

end