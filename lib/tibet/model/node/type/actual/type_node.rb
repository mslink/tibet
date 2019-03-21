
module Tibet

# note
# use in/out edges for raw access
# use accessors for edge types for visible access

  class TypeNode < ActualNode

    include InheritanceSupport
    include MarkerSupport

    def initialize(*args)
      super

      @origin = :pristine
    end

    # contract #MarkerSupport
    def annotations
      vertex.annotations
    end

    #

    def type?
      true
    end

    def covers_type?(type)
      self.eql?(type)
    end

    #

    def enumerate?
      marker? ->(c) {c =~ /<enumerate>/}
    end

    #

    # note alternative:
    # duplicate edges, therefore an edge should not register itself in source / target nodes
    # this registration could be done from outside, separating concerns and keeping encapsulation
    def proxy_edges(edges, role)
      edges
        .flatten
        .map{|edge| EdgeInheritanceProxy.new(edge, self, role)}
    end

    #

    # full inheritance (classification & inclusion)
    def attributions
      proxy_edges(_attributions, :source)
    end

    # via out edges
    def _attributions
      out_edges
        .select(&:visible?)
        .select(&:attribution?) +

        parents([:classification?, :inclusion?])
          .map(&:_attributions)
    end

    #

    def in_associations(*args)
      proxy_edges(_in_associations(*args), :target)
    end

    def out_associations(*args)
      proxy_edges(_out_associations(*args), :source)
    end

    #

    # no inheritance
    def in_classifications
      in_edges
        .select(&:visible?)
        .select(&:classification?)
    end

    # no inheritance
    def out_classifications
      out_edges
        .select(&:visible?)
        .select(&:classification?)
    end

    #

    # no inheritance
    def restrictions
      out_edges
        .select(&:visible?)
        .select(&:restriction?)
    end

    #

    # full inheritance (classification & inclusion)
    def ___semantics
      proxy_edges(_semantics, :source)
    end

    # consider
    # using abstract #recursive_ascend(edge-predicate, axes) method -
    # also for other node properties
    #
    # via out edges
    def _semantics
      out_edges
        .select(&:visible?)
        .select(&:semantic?) +

        # check direct usage of #ancestors method
        parents([:classification?, :inclusion?])
          .map(&:_semantics)
    end

    # caution no inheritance
    # via out edges
    def semantics
      out_edges
        .select(&:visible?)
        .select(&:semantic?)
    end

    #

    # inheritance
    # note direct inheritance via model structure
    # (not via additional ruby classes / modules at application runtime)
    def in_supplies
      proxy_edges(_supplies(:in_edges), :target)
    end

    def out_supplies
      proxy_edges(_supplies(:out_edges), :source)
    end

    def _supplies(edges_id)
      send(edges_id)
        .select(&:visible?)
        .select(&:supply?) +

        parents([:classification?, :inclusion?])
          .map{|p| p._supplies(edges_id)}
    end

    #

    # no inheritance
    def connectors
      out_edges
        .select(&:visible?)
        .select(&:connector?)
    end

    #

    def attributes
      attributions
        .map(&:target_end)
        .map(&:client)
    end

    #

    def in_associates
      in_associations
        .map(&:source_end)
        .map(&:client)
    end

    def out_associates
      out_associations
        .map(&:target_end)
        .map(&:client)
    end

    #

    def classes
      out_classifications
        .map(&:target_end)
        .map(&:client)
    end

    #

    def modules
      inclusions
        .map(&:target_end)
        .map(&:client)
    end

    #

    def propagate_depth(depth = 0)
      @depth = [@depth || 0, depth += 1].max
      children([:classification?, :inclusion?]).each {|child| child.propagate_depth(depth)}
    end

  end

end