
module Tibet

  class ElementRefinement

    attr_reader :model,
                :result

    def initialize(model)
      @model = model
    end

    def valid?
    end

    def do_not_add
      false
    end

    def do_not_hide
      false
    end

    def write_through
      false
    end

  end

end