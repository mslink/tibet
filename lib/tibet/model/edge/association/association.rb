
module Tibet

  class Association < Edge

    def self.kind
      :none
    end

    def kind
      :none
    end

    def association?
      true
    end

    def aggregation?
      false
    end

    def composition?
      false
    end

    def one_to_one?
      false
    end

    def one_to_many?
      false
    end

    def many_to_one?
      false
    end

    def many_to_many?
      false
    end

    def polymorphic_member?
      volatiles.dig(:overlays, :polymorphic)
    end

    def transitive_member?
      volatiles.dig(:overlays, :transitive)
    end

    def to_s
      "#{super} [polymorphic: #{!polymorphic_member?.nil?}]"
    end

  end

end