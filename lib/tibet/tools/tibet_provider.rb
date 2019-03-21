
# require_relative '../dependencies'

module Tibet

  class TibetProvider

    def self.model(schema_path)
      TibetController.new(schema_path).run
    end

  end

end