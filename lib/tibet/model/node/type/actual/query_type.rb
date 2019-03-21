
module Tibet

# todo validate query type has 'result'-property

  class QueryType < EntityType

    def concrete?
      true
    end

    def entity?
      false
    end

    def query?
      true
    end

  end

end