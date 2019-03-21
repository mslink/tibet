
module Tibet

  class SupplyEdge < Edge

    def supply?
      true
    end

    def name
      center_annotations.first
    end

    # note edge is accessed directly, not via endpoint (as usual)

    def source_access_path
      _access_path(source_annotations)
    end

    def target_access_path
      _access_path(target_annotations)
    end

    # avoid calculating regular expression multiple times
    def declaration
      re = /(\w*)(?::(\w*))?(?::(\w*))?(?::(\w*))?/

      candidate = center_annotations.detect{|ca| ca =~ re}

      unless candidate
        fail "--error: syntax error on supply edge declaration, see #{[source_end.client.name, target_end.client.name]}"
      end

      analyzed = candidate.match(re)
    end

    def show_producer?
      # center_annotations.detect{|ca| ca =~ /show:.*/}
      declaration[1].eql?('show')
    end

    def show_consumer?
      # center_annotations.detect{|ca| ca =~ /.*:(show|\*)/}
      declaration[2].eql?('show')
    end

    def new_consumer?
      # center_annotations.detect{|ca| ca =~ /.*:(new|\*)/}
      declaration[2].eql?('new')
    end

    def hybrid_consumer?
      # center_annotations.detect{|ca| ca =~ /.*:(hybrid|\*)/}
      declaration[2].eql?('hybrid')
    end

    # default
    def bottom_consumer?
      declaration[3] ? declaration[3].eql?('bottom') : true
    end

    # note top, right, bottom, left is layout position

    def layout_mode
      declaration[4] || 'dynamic'
    end

    private

    # avoid global regex result access
    def _access_path(annotations)
      annotations.detect{|annotation| annotation =~ /\[(.*)\]/}
      $1 ? $1.split(/,/).map(&:strip).map{|e| e.delete(':')} : []
    end

  end

end