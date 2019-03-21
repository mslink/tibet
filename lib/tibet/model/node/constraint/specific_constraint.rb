
module Tibet

  class SpecificConstraint < Node

    attr_reader :client

    def initialize(client)
      super()

      @client = client
    end

    def constraint?
      true
    end

    def format?
      false
    end

    def interval?
      false
    end

    def inclusion?
      false
    end

    def exclusion?
      false
    end

    def name
      client.name
    end

    def type
      client.type
    end

    def content
      client.content
    end

  end

end