
module Tibet

  class Parser

    attr_reader :fn,
                :doc

    def initialize(fn)
      @fn = fn

      @doc = REXML::Document.new(File.open(fn))
    end

    def namespace
      File.basename(fn)
    end

    def scan_vertices
      # doc.elements.to_a('/graphml/graph/node')
      _scan_vertices
    end

    def scan_arcs
      # doc.elements.to_a('/graphml/graph/edge')
      _scan_arcs
    end

    private

    def _scan_vertices
      reject_ignored(doc.elements.to_a('/graphml/graph/node'))
    end

    def _scan_arcs
      reject_ignored(doc.elements.to_a('/graphml/graph/edge'))
    end

    # reject element, iff
    # * :ignore string is detected (:ignore)
    # * element color is #999999 (color='#999999')
    #   note (to_s returns <'> not <">)
    def reject_ignored(elements)
      elements
        .reject { |e| e.to_s =~ /:ignore/ }
        .reject { |e| e.to_s =~ /color='#999999'/ }
    end

  end

end