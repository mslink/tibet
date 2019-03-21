
module Tibet

  class Constraint < ActualNode

    def constraint?
      true
    end

    def name
      vertex.annotations.detect {|candidate| candidate =~ name_pattern} || vertex.qualified_id
    end

    def type
      literal_type_of(vertex.annotations.detect {|candidate| candidate =~ type_pattern})
    end

    def content
      vertex.annotations.detect {|candidate| candidate =~ content_pattern}
    end

    private

    def name_pattern
      /^[a-z][a-zA-Z0-9_]{,32}/
    end

    def type_pattern
      /^(IN|EX|\[\]|~){1,1}$/
    end

    def literal_type_of(shortcut)
      type_key = shortcut.to_sym
      {:'IN' => :inclusion, :'EX' => :exclusion, :'[]' => :interval, :'~'  => :format}[type_key]
    end

    def content_pattern
      /^(\{|\d|\/).*$/
    end

  end

end