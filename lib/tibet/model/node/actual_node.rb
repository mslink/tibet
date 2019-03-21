
module Tibet

  class ActualNode < Node

    attr_reader :vertex

    def initialize(vertex)
      super()

      @vertex = vertex
    end

  end

end