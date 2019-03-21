
module Tibet

  # overwrites properties of default edges making them independent from underlying xml artefacts

  module VirtualEdgeSupport

    attr_accessor :qualified_id,
                  :name,

                  # edge override

                  :origin,

                  :source_role_name,
                  :target_role_name,

                  :source_browse,
                  :target_browse,

                  :polymorphic_source_group_name,
                  :polymorphic_target_group_name,

                  :source_navigable,
                  :target_navigable,

                  :source_inhibitive,
                  :target_inhibitive,

                  :source_transitive,
                  :target_transitive,

                  :source_functional,
                  :target_functional,

                  :source_multiplicity,
                  :target_multiplicity,

                  :source_links_associated,
                  :target_links_associated,

                  :source_builds_associated,
                  :target_builds_associated,

                  :source_index,
                  :target_index,

                  :source_internal,
                  :target_internal,

                  :source_secure,
                  :target_secure,

                  :source_nesting,
                  :target_nesting,

                  :source_non_nesting,
                  :target_non_nesting,

                  :source_final,
                  :target_final,

                  :source_owner_property,
                  :target_owner_property,

                  :source_unique,
                  :target_unique,

                  :source_ordered,
                  :target_ordered,

                  :edge_connectors,

                  :source_pierced,
                  :target_pierced,

                  :source_participant,
                  :target_participant,

                  # *-association override

                  :source_required,
                  :target_required,

                  # annotation override
                  :target_annotations

    def self.included(component)

      def component.build_from(edge)
        new = new(edge.source_node, edge.target_node)
        new.adopt(edge)
        new
      end

    end

    def initialize(source_node, target_node)
      super(nil, source_node, target_node)

      # consider initializing default property values here
      @target_annotations = []
    end

    def edge_connectors
      []
    end

    # see refactor comment in #EdgeModifierSupport
    def ___source_marker?(spec)
    end

    def ___target_marker?(spec)
    end

    def ___source_markers?(spec)
      []
    end

    def ___target_markers?(spec)
      []
    end

    # cloning must respect, that the master source/target
    # nodes can be changed in the endpoints
    def clone
      duplicate = self.class.new(source_end.client, target_end.client)
      duplicate.adopt(self)

      duplicate
    end

    def source_annotations
      []
    end

    def center_annotations
      []
    end

    # def target_annotations
    #   []
    # end

    def name
      @name || super
    end

    protected

    # check edge volatiles are not respected (also see other adopt methods)
    def adopt(master)

      volatiles.merge!(master.volatiles)

      source_end.volatiles.merge!(master.source_end.volatiles)
      target_end.volatiles.merge!(master.target_end.volatiles)

      self.qualified_id = object_id

      self.name = master.name

      # edge override

      self.origin = master

      self.source_role_name = master.source_end.role_name
      self.target_role_name = master.target_end.role_name

      self.source_browse = master.source_browse
      self.target_browse = master.target_browse

      self.source_multiplicity = master.source_multiplicity
      self.target_multiplicity = master.target_multiplicity

      self.polymorphic_source_group_name = master.polymorphic_source_group_name
      self.polymorphic_target_group_name = master.polymorphic_target_group_name

      self.source_navigable = master.source_navigable
      self.target_navigable = master.target_navigable

      self.source_inhibitive = master.source_inhibitive
      self.target_inhibitive = master.target_inhibitive

      self.source_transitive = master.source_transitive
      self.target_transitive = master.target_transitive

      self.source_functional = master.source_functional
      self.target_functional = master.target_functional

      self.source_multiplicity = master.source_multiplicity
      self.target_multiplicity = master.target_multiplicity

      self.source_links_associated = master.source_links_associated
      self.target_links_associated = master.target_links_associated

      self.source_builds_associated = master.source_builds_associated
      self.target_builds_associated = master.target_builds_associated

      self.source_index = master.source_index
      self.target_index = master.target_index

      self.source_internal = master.source_internal
      self.target_internal = master.target_internal

      self.source_secure = master.source_secure
      self.target_secure = master.target_secure

      self.source_nesting = master.source_nesting
      self.target_nesting = master.target_nesting

      self.source_non_nesting = master.source_non_nesting
      self.target_non_nesting = master.target_non_nesting

      self.source_final = master.source_final
      self.target_final = master.target_final

      self.source_owner_property = master.source_owner_property
      self.target_owner_property = master.target_owner_property

      self.source_unique = master.source_unique
      self.target_unique = master.target_unique

      self.source_ordered = master.source_ordered
      self.target_ordered = master.target_ordered

      self.edge_connectors = master.edge_connectors

      self.source_pierced = master.source_pierced
      self.target_pierced = master.target_pierced

      self.source_participant = master.source_participant
      self.target_participant = master.target_participant

      # *-association override

      self.source_required = master.source_required
      self.target_required = master.target_required

    end

  end

end