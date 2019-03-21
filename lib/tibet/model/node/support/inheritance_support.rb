
module Tibet

  module InheritanceSupport

    # note inheritance is realised by following classification / inclusion edges (axes)

    def _parents(axes)

      fail '-- inheritance error' unless axes.kind_of?(Array)

      return [] if axes.empty?

      out_edges
        .select(&:visible?)
        .select{|e| axes.any?{|a| e.send(a)}}
        .map(&:target_client)
    end

    def _children(axes)

      fail '-- inheritance error' unless axes.kind_of?(Array)

      return [] if axes.empty?

      in_edges
        .select(&:visible?)
        .select{|e| axes.any?{|a| e.send(a)}}
        .map(&:source_client)
    end

    def _ancestors(axes)
      _parents(axes) + _parents(axes).map{|p| p._ancestors(axes)}.flatten
    end

    def _descendants(axes)
      _children(axes) + _children(axes).map{|p| p._descendants(axes)}.flatten
    end

    def has_ancestors?
      !ancestors.empty?
    end

    def has_descendants?
      !descendants.empty?
    end

  end

end