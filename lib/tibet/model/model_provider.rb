
module Tibet

  class ModelProvider

    attr_reader :controller,
                :graph

    def initialize(controller, graph)
      @controller = controller
      @graph = graph
    end

    def deliver
      ModelBuilder.new(controller, graph).perform
    end

  end

end