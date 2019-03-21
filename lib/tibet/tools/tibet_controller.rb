
module Tibet

  class TibetController

    attr_reader :schema_path,
                :graphs,
                :model

    def initialize(schema_path)
      @schema_path = schema_path

      @graphs = []
      @model = nil
    end

    def fetch_graph(source_path)
      GraphProvider.new(source_path).deliver
    end

    def run

      # first, instantiate graph of main model
      graphs << fetch_graph(schema_path)

      # second, instantiate model instance
      @model = ModelProvider.new(self, graphs.first).deliver

    end

  end

end