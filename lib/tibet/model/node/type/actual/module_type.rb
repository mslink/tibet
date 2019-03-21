
module Tibet

# note inheritance based on monomorphism (physical inheritance)

  class ModuleType < TypeNode

    # clony section to #EntityType
    def ancestors(axes = [:inclusion?])
      _ancestors(axes)
    end

    def parents(axes = [:inclusion?])
      _parents(axes)
    end

    def children(axes = [:inclusion?])
      _children(axes)
    end

    def descendants(axes = [:inclusion?])
      _descendants(axes)
    end
    # /clony

    #

    def _in_associations(axes = [])

      # default is inclusion
      if axes.eql?(:all_axes)
        axes = [:inclusion?]
      end

      in_edges
        .select(&:visible?)
        .select(&:association?)  +

        parents(axes)
          .map{|e| e._in_associations(axes)}
    end

    def _out_associations(axes = [])

      # default is inclusion
      if axes.eql?(:all_axes)
        axes = [:inclusion?]
      end

      out_edges
        .select(&:visible?)
        .select(&:association?)  +

        parents(axes)
          .map{|e| e._out_associations(axes)}
    end

    #

    def abstract?
      true
    end

    def module?
      true
    end

    def users
      children
    end

    # Contract #ClassModelTemplate
    def members
      children
    end

  end

end