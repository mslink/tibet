
module Tibet

  class VirtualSupplyEdge < SupplyEdge

    include VirtualEdgeSupport

    attr_accessor :source_access_path,
                  :target_access_path

    # consider overriding center annotations with declaration

    def name
      nil
    end

    def show_producer?
      true
    end

    def show_consumer?
      false
    end

    def new_consumer?
      true
    end

    def hybrid_consumer?
      false
    end

    def bottom_consumer?
      true
    end

    def layout_mode
      'dynamic'
    end

  end

end