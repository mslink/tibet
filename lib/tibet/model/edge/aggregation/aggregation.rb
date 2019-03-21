
module Tibet

  class Aggregation < Association

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