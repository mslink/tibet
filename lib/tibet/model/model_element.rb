
module Tibet

  class ModelElement

    attr_reader   :volatiles
    attr_accessor :origin

    def initialize
      @volatiles = {}

      @volatiles[:hidden] = false
    end

    def element?
      true
    end

    def node?
      false
    end

    def type?
      false
    end

    def edge?
      false
    end

    def endpoint?
      false
    end

    def overlay?
      false
    end

    def hide!
      Report.info("#{self.class} hiding #{self}")
      volatiles[:hidden] = true
    end

    def show!
      Report.info("#{self.class} showing #{self}")
      volatiles[:hidden] = false
    end

    def hidden?
      volatiles[:hidden]
    end

    def visible?
      !volatiles[:hidden]
    end

    def name
      "#{object_id}"
    end

    def to_s
      # "#{self.class} [object id: #{name}] {hidden: #{@volatiles[:hidden]}}"
      "#{self.class} #{name} {hidden: #{volatiles[:hidden]}}"
    end

    #

    # 'tr_' prefix for 'tibet reflection'
    def method_missing(id, *args)
      prefix = 'tr' << '_'

      if id.to_s.start_with?(prefix)
        return id.to_s.gsub(prefix, '').eql?(name)
      end

      super
    end

  end

end