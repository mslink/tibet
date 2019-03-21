
module Tibet

  class ModelOverlay < ModelElement

    def overlay?
      true
    end

    def to_s
      "#{self.class}"
    end

  end

end