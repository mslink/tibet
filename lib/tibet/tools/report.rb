
module Tibet

  class Report

    include Singleton

    COLON =   ':'
    NEWLINE = "\n"

    # levels: unknown, fatal, error, warn, info, debug, develop

    def self.unknown(*msg)
      instance.add(:unknown, msg)
    end

    def self.fatal(*msg)
      instance.add(:fatal, msg)
    end

    def self.error(*msg)
      instance.add(:error, msg)
    end

    def self.warn(*msg)
      instance.add(:warn, msg)
    end

    def self.info(*msg)
      instance.add(:info, msg)
    end

    def self.debug(*msg)
      instance.add(:debug, msg)
    end

    def self.develop(*msg)
      instance.add(:develop, msg)
    end

    #

    def self.flush
      instance.flush
    end

    def initialize
      @messages = []

      @write_through = false
    end

    def write_through=(boolean)
      @write_through = boolean
    end

    def format(tuple)
      tuple.join(COLON)
    end

    def add(type, msg)
      @messages << tuple = [type, msg]

      puts format(tuple) if @write_through
    end

    def flush
      puts (['Report:'] + @messages.map {|tuple| format(tuple)}).map {|msg| "#{msg}#{NEWLINE}"}
    end

  end

  $R = Report

end