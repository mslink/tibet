
module Tibet

# note
#
# taxonomy is usually only a hierarchy of concepts
# (i.e., the only relation between the concepts is parent/child, or superClass/subClass, or broader/narrower)
#
# in an ontology, arbitrary complex relations between concepts can be expressed too
# (X marriedTo Y; or A worksFor B; or C locatedIn D, etc.)
#
# note inheritance based on polymorphism at application runtime

  class ClassType < TypeNode

    def covers_type?(type)
      self.eql?(type) || descendants.include?(type)
    end

    #

    # clony section to #EntityType
    def ancestors(axes = [:classification?])
      _ancestors(axes)
    end

    def parents(axes = [:classification?])
      _parents(axes)
    end

    def children(axes = [:classification?])
      _children(axes)
    end

    # caution including siblings
    def ___descendants(axes = [:classification?])
      _descendants(axes) + siblings
    end

    def descendants(axes = [:classification?])
      _descendants(axes)
    end
    # /clony

    #

    def _in_associations(axes = [])

      # default is classification
      if axes.eql?(:all_axes)
        axes = [:classification?]
      end

      # check direct usage of ancestors-method
      in_edges
        .select(&:visible?)
        .select(&:association?)  +

        parents(axes)
          .map{|e| e._in_associations(axes)}
    end

    def _out_associations(axes = [])

      # default is classification
      if axes.eql?(:all_axes)
        axes = [:classification?]
      end

      # check direct usage of #ancestors method
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

    def class?
      true
    end

    # consider 'uncles',
    # see https://en.wikipedia.org/wiki/Tree_structure
    # semantics unclear
    def siblings
      parents.map(&:children).flatten - [ self ]
    end

    def ___members
      children + siblings
    end

    def members
      children
    end

  end

end