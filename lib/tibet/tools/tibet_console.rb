
module Tibet

  class TibetConsole

    def initialize(model)
      @model = model
    end

    def ___handle_input(input)
      result = eval(input)
      puts("=> #{result}")
    end

    def ___repl
      repl = -> prompt do
        print prompt
        _handle_input(STDIN.gets.chomp!)
      end

      loop do
        repl['>> ']
      end
    end

    def ___run
      Ripl.start binding: binding
    end

    def get(element)
      @model.elements.detect(&:"tr_#{element}".to_sym)
    end

    def run
      binding.pry
    end

  end

end