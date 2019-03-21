
module Tibet

  class VirtualAttribute < Attribute

    attr_reader :name,
                :data_type

    # virtual override
    attr_accessor :browse,
                  :index,
                  :secure

    def initialize(name, data_type)
      super(nil)

      @name = name
      @data_type = data_type

      # @volatiles[:position] = Float::INFINITY
    end

    # workaround
    def annotations
      []
    end

    def required?
      true
    end

    def optional?
      false
    end

    def unique?
      false
    end

    def secure?
      secure
    end

    def browse?
      browse
    end

    def index?
      index
    end

    def internal?
      false
    end

    def final?
      false
    end

    def nesting?
      false
    end

    def non_nesting?
      true
    end

  end

end