
module Tibet

# check abstract #Navigation
# check consider extension modules for polymorphic/transitive association support

# consider Endpoint, Property and Port as synonyms here

  class Endpoint < ModelElement

    # include CustomUIControlSupport

    attr_reader :edge,
                :client,
                :role

    def initialize(edge, client, role)
      super()

      @edge = edge

      # source or target node
      @client = client

      # direction role (source / target)
      # note required for reflexive edges
      @role = role

    end

    #

    def ==(other)
      hash == other.hash
    end

    def eql?(other)
      self == other
    end

    # idem Endpoint vs. same Endpoint
    def hash
      [edge, client, role].hash
    end

    #

    def endpoint?
      true
    end

    def name
      role_name
    end

    # check: this does not seem to work properly
    # check: in/out reference list in client will be inconsistent
    def change_client(client)
      fail '-- error: client may not be nil' unless client

      @client = client
    end

    def source_end?
      edge.source_end.eql?(self)
    end

    def target_end?
      edge.target_end.eql?(self)
    end

    def counter_end
      source_end? ? edge.target_end : edge.source_end
    end

    # contract #MarkerSupport
    def annotations
      source_end? ? edge.source_annotations : edge.target_annotations
    end

    def ___s_anno
      edge.source_annotations
    end

    def ___t_anno
      edge.target_annotations
    end

    # role name via edge, then by client
    def role_name
      (source_end? ? edge.source_role_name : edge.target_role_name) || client.name.singularize.underscore
    end

    def has_role_name?
      role_name
    end

    def browse?
      (source_end? ? edge.source_browse : edge.target_browse)
    end

    def index?
      (source_end? ? edge.source_index : edge.target_index)
    end

    # check MarkerSupport included
    def marker?(spec)
      (source_end? ? edge.source_marker?(spec) : edge.target_marker?(spec))
    end

    # check MarkerSupport included
    def markers?(spec)
      (source_end? ? edge.source_markers?(spec) : edge.target_markers?(spec))
    end

    def polymorphic_group_name
      name = source_end? ? edge.polymorphic_source_group_name : edge.polymorphic_target_group_name
      name&.empty? ? role_name : name
    end

    def has_polymorphic_group_name?
      polymorphic_group_name
    end

    def navigable?
      source_end? ? edge.source_navigable : edge.target_navigable
    end

    def inhibitive?
      source_end? ? edge.source_inhibitive : edge.target_inhibitive
    end

    def ___non_navigable?
      !navigable?
    end

    def transitive?
      source_end? ? edge.source_transitive : edge.target_transitive
    end

    def non_transitive?
      !transitive?
    end

    def functional?
      source_end? ? edge.source_functional : edge.target_functional
    end

    def ___non_functional?
      !functional?
    end

    def pierced?
      source_end? ? edge.source_pierced : edge.target_pierced
    end

    def participant?
      source_end? ? edge.source_participant : edge.target_participant
    end

    def owner_property?
      source_end? ? edge.source_owner_property : edge.target_owner_property
    end

    def links_associated?
      source_end? ? edge.source_links_associated : edge.target_links_associated
    end

    def builds_associated?
      source_end? ? edge.source_builds_associated : edge.target_builds_associated
    end

    def internal?
      source_end? ? edge.source_internal : edge.target_internal
    end

    def secure?
      source_end? ? edge.source_secure : edge.target_secure
    end

    def final?
      source_end? ? edge.source_final : edge.target_final
    end

    def nesting?
      source_end? ? edge.source_nesting : edge.target_nesting
    end

    def non_nesting?
      source_end? ? edge.source_non_nesting : edge.target_non_nesting
    end

    def unique?
      source_end? ? edge.source_unique : edge.target_unique
    end

    def ordered?
      source_end? ? edge.source_ordered : edge.target_ordered
    end

    # possible navigation result:
    #
    # * plain attribute value
    # * single object
    # * collection of objects
    #   * set
    #   * sequence
    #   * ordered set
    #   * bag

    def plain?
      false
    end

    def single?
      to_one?
    end

    def collection?
      to_many?
    end

    def collection_set?
      unique? && !ordered?
    end

    def collection_sequence?
      !unique? && ordered?
    end

    def collection_ordered_set?
      unique? && ordered?
    end

    def collection_bag?
      !unique? && !ordered?
    end

    def optional?
      modality.eql?(0)
    end

    # experimental semantics
    def required?
      modality > 0 || functional?
    end

    # refactor: move all multiplicity code via source/target prefixes to #EdgeMultiplicitySupport

    def to_one?
      literal_cardinality.eql?(:one)
    end

    def to_many?
      literal_cardinality.eql?(:more)
    end

    def multiplicity
      source_end? ? edge.source_multiplicity : edge.target_multiplicity
    end

    def modality
      multiplicity[0] if multiplicity # check condition needed?
    end

    def literal_modality
      return unless modality

      return :zero if modality.eql?(0)
      :one if modality.eql?(1)
    end

    # todo synchronize case handling of '*'
    # with #EdgeMultiplicitySupport for DERIVED
    # edges. clear '*' vs. :'*'
    def cardinality
      x = nil
      x = multiplicity[1] if multiplicity
      x.eql?(:*) ? 256 : x
    end

    def literal_cardinality
      return unless cardinality

      return :one if cardinality.eql?(1)
      :more if cardinality > 1
    end

    def literal_multiplicity
      return :zero_or_one   if multiplicity.eql?([0,1])
      return :one           if multiplicity.eql?([1,1])

      upper = multiplicity[1]

      if upper.kind_of?(Symbol) && upper.eql?(:*)
        return :zero_or_more if multiplicity[0].eql?(0)
        return :one_or_more if multiplicity[0].eql?(1)
      end

      if upper.kind_of?(Integer) && upper > 1
        return :zero_or_more if multiplicity[0].eql?(0)
        return :one_or_more if multiplicity[0].eql?(1)
      end

      fail "error: multiplicity error (#{self.class})"
    end

    def to_s
      "#{self.class} with name #{role_name} #{volatiles}"
    end

  end

end