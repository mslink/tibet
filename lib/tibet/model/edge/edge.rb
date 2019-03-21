
module Tibet

# todo refactor note: reflexive edges are doubled!

  class Edge < ModelElement

    # todo refactor!
    # nodes -> endpoints -> source/target nodes
    # no parallel managing of source/target nodes and source/target ends
    # see comments below
    # refactor the problem is: edge -> endpoint -> node, but node ->> edge, node \ endpoint

    include EdgeModifierSupport
    include EdgePredicateSupport
    include EdgeMultiplicitySupport

    include HyperEdgeSupport

    attr_reader :arc,
                # :source_node,
                # :target_node,
                :source_end,
                :target_end,
                :origin

    RED = '#FF0000'

    # todo
    # edge is SELF-REGISTERING through **1
    # refactor this behaviour! and remove register-parameter again used by #clone* methods
    def initialize(arc, source_node, target_node, register = true)
      super()

      @arc = arc

      # check update of source/target node vs. source_end/target_end client updates
      # note hide source- and target-node for the sake of encapsulation (with Endpoint, e.g.)
      # @source_node = source_node
      # @target_node = target_node

      # check immediate instantiation of endpoints
      @source_end = Endpoint.new(self, source_node, :source)
      @target_end = Endpoint.new(self, target_node, :target)

      # check architecture: should nodes only have access to endpoints? **1
      # pull node-registration out from constructor
      if register
        source_node.add_out_edge(self)
        target_node.add_in_edge(self)
      end

      @origin = arc

      # tell edge connector nodes on which edge they reside
      edge_connectors.each {|ec| ec.base = self}

      Report.info("#{self.class} created #{self}")
    end

    def edge?
      true
    end

    def edge_connectors
      arc.edge_connectors
    end

    def self.build_from(edge)
      new = new(edge.arc, edge.source_end.client, edge.target_end.client)
      new.adopt(edge)
      new
    end

    # cloning must respect, that the original source/target
    # nodes could have been changed in the endpoints
    def clone
      duplicate = self.class.new(arc, source_end.client, target_end.client)
      duplicate.adopt(self)
      duplicate
    end

    def clone_with_new_source(source_node)
      duplicate = self.class.new(arc, source_node, target_end.client, false)
      duplicate.adopt(self)
      duplicate
    end

    def clone_with_new_target(target_node)
      duplicate = self.class.new(arc, source_end.client, target_node, false)
      duplicate.adopt(self)
      duplicate
    end

    # check edge volatiles are not respected (also see other adopt methods)
    def adopt(master)

      volatiles.merge!(master.volatiles)

      source_end.volatiles.merge!(master.source_end.volatiles)
      target_end.volatiles.merge!(master.target_end.volatiles)

      self.origin = master
    end

    # delegate to endpoints
    def hide!
      super

      source_end.hide!
      target_end.hide!
    end

    #



    #

    def source_client
      source_end.client
    end

    def target_client
      target_end.client
    end

    #

    # virtual-override
    def qualified_id
      arc.qualified_id
    end

    #

    def cartesian_y
      arc.cartesian_y
    end

    # ***1

    def source_annotations
      arc.source_annotations
    end

    def center_annotations
      arc.center_annotations
    end

    def target_annotations
      arc.target_annotations
    end

    #

    # virtual-override
    def name
      # note naming semantically misleading, if one-to-one
      _edge_name(center_annotations) || "#{source_end.role_name.pluralize}_#{target_end.role_name.pluralize}"
    end

    # virtual-override
    def source_role_name
      _role_name(source_annotations)
    end

    # virtual-override
    def target_role_name
      _role_name(target_annotations)
    end

    #

    def source_label_bold(label)
      arc.source_label_bold?(label)
    end

    def target_label_bold(label)
      arc.target_label_bold?(label)
    end

    def source_label_italic(label)
      arc.source_label_italic?(label)
    end

    def target_label_italic(label)
      arc.target_label_italic?(label)
    end

    def source_label_underlined(label)
      arc.source_label_underlined?(label)
    end

    def target_label_underlined(label)
      arc.target_label_underlined?(label)
    end

    #

    # virtual-override
    def polymorphic_source_group_name
      _polymorphic_group_name(source_annotations)
    end

    # virtual-override
    def polymorphic_target_group_name
      _polymorphic_group_name(target_annotations)
    end

    # virtual-override
    def source_navigable
      _navigable?(arc.source_arrow)
    end

    # virtual-override
    def target_navigable
      _navigable?(arc.target_arrow)
    end

    # virtual-override
    def source_inhibitive
      _inhibitive?(arc.source_arrow)
    end

    # virtual-override
    def target_inhibitive
      _inhibitive?(arc.target_arrow)
    end

    # virtual-override
    def source_transitive
      _transitive?(arc.source_arrow)
    end

    # virtual-override
    def target_transitive
      _transitive?(arc.target_arrow)
    end

    # virtual-override
    def source_functional
      _functional?(arc.source_arrow)
    end

    # virtual-override
    def target_functional
      _functional?(arc.target_arrow)
    end

    # virtual-override
    def source_pierced
      _pierced?(arc.source_arrow)
    end

    # virtual-override
    def target_pierced
      _pierced?(arc.target_arrow)
    end

    # virtual-override
    def source_participant
      _participant?(arc.source_arrow)
    end

    # virtual-override
    def target_participant
      _participant?(arc.target_arrow)
    end

    # open
    # implement reflexive overlay;
    # this definition only considers _direct_ reflexiveness
    # but indirect reflexiveness via classes, etc. is also possible
    def reflexive
      # see ReflexiveAssociationDetectionRefinement
      !!volatiles.dig(:overlays, :reflexive)
    end

    def tentative
      arc.color.eql?(RED)
    end

    def to_s
      #"#{source_end.client.name} [mid:#{source_end.client.__id__}] -> #{target_end.client.name} [mid:#{target_end.client.__id__}] (#{source_end.client.class} -> #{target_end.client.class}) via #{self.class} #{self.volatiles} [mid:#{self.__id__}]"
      "#{source_end.client.name} -> #{target_end.client.name} (#{source_end.client.class} -> #{target_end.client.class}) via #{self.class} [hidden: #{self.volatiles[:hidden]}]"
    end

    private

    def _navigable?(arrow)
      !arrow.eql?('skewed_dash')
    end

    # semantics?
    def _inhibitive?(arrow)
      arrow.eql?('transparent_circle')
    end

    def _transitive?(arrow)
      arrow.eql?('short')
    end

    def _functional?(arrow)
      arrow.eql?('standard')
    end

    def _pierced?(arrow)
      arrow.eql?('dash')
    end

    def _participant?(arrow)
      arrow.eql?('t_shape')
    end

    def _edge_name(annotations)
      annotations.detect{|candidate| candidate =~ edge_name_pattern}
    end

    def _role_name(annotations)
      annotations.detect{|candidate| candidate =~ role_name_pattern}
    end

    def _polymorphic_group_name(annotations)
      match = annotations.detect{|candidate| candidate =~ polymorphic_group_name_pattern}
      match&.gsub(/pm/, '')&.gsub(/:/, '')
    end

    def edge_name_pattern
      /^([a-z][a-z0-9_]{2,})$/
    end

    def role_name_pattern
      /^([a-z][A-Za-z0-9_]{2,})$/
    end

    # todo should support blanks
    # pm:<name> | pm
    def polymorphic_group_name_pattern
      /^(pm:([a-z][A-Za-z0-9_])+)|(pm)$/
    end

  end

end