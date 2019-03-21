
module Tibet

# caution in/out via module and proxy/clone edges are dirty!

  class EntityType < TypeNode

    def ancestors(axes = [:classification?])
      _ancestors(axes)
    end

    def parents(axes = [:classification?])
      _parents(axes)
    end

    def children(axes = [:classification?])
      _children(axes)
    end

    def descendants(axes = [:classification?])
      _descendants(axes)
    end

    #

    # clean in_via_module
    def in_associations(*args)
      ins = _in_associations(*args) + in_via_module
      proxy_edges(ins, :target)
    end

    # clony
    def _in_associations(axes = [:inclusion?])

      if axes.eql?(:all_axes)
        axes = [:classification?, :inclusion?]
      end

      in_edges
        .select(&:visible?)
        .select(&:association?) +

        parents(axes)
          .map{|e| e._in_associations(axes)}
    end
    # /clony

    # clony
    def in_via_module
      modules
        .map{|m| m._in_associations([:inclusion?])}
        .flatten
        .map{|edge| edge.clone_with_new_target(self)}
    end
    # /clony

    #

    # clean out_via_module
    def out_associations(*args)
      outs = _out_associations(*args) + out_via_module
      proxy_edges(outs, :source)
    end

    # clony
    def _out_associations(axes = [:inclusion?])

      if axes.eql?(:all_axes)
        axes = [:classification?, :inclusion?]
      end

      out_edges
        .select(&:visible?)
        .select(&:association?) +

        parents(axes)
          .map{|e| e._out_associations(axes)}
    end
    # /clony

    # clony
    def out_via_module
      modules
        .map{|m| m._out_associations([:inclusion?])}
        .flatten
        .map{|edge| edge.clone_with_new_source(self)}
    end
    # /clony

    #

    def inclusions
      out_edges
        .select(&:visible?)
        .select(&:inclusion?)
    end

    #

    def concrete?
      true
    end

    def entity?
      true
    end

    # todo definition implictly via composition, e.g., or explicitly via model annotation
    def strong?
      fail '-- error: requires definition'
    end

    # todo definition implictly via composition, e.g., or explicitly via model annotation
    def weak?
      fail '-- error: requires definition'
    end

  end

end