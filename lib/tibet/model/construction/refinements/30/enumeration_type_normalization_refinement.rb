
module Tibet

  class EnumerationTypeNormalizationRefinement < ElementRefinement

    # note *1
    # generates attributes on each occurrence
    # currently, this transformation ist not possible on derived types
    # as the edge-construction process requires add_in/out_edge methods
    # to register itself on the nodes

    def do_not_add
      true
    end

    def do_not_hide
      true
    end

    def write_through
      true
    end

    def match(node)
      return unless node.enumeration?

      # workaround for *1 above
      @@handled ||= []
      return if @@handled.include?(node.name)
      #

      unless node.name =~ /[[:alpha:]]+Element/
        abort "-- error: enumeration type name error @#{node.name}, 'Element' suffix not found"
      end

      edges = []

      unless node.attributes.map(&:name).include?('constant')
        attribute_constant = VirtualAttribute.new('constant', :string)
        # attribute_constant.browse = node.browse?
        # attribute_constant.index = node.index?
        edges << VirtualAttributionEdge.new(node, attribute_constant)
      end

      unless node.attributes.map(&:name).include?('name_de_de')
        attribute_name_de_de = VirtualAttribute.new('name_de_de', :string)
        # attribute_name_de.browse = node.browse?

        # note align modifiers on edge (see below) vs. modifiers on attributes (via / not via edge rebound)
        # attribute_name_de.index = node.index?

        # note derive attribute modifiers from incoming association of enumeration

        # experimental
        attribute_name_de_de.secure = false
        attribute_name_de_de.index = true

        va_edge = VirtualAttributionEdge.new(node, attribute_name_de_de)
        va_edge.target_annotations = ['@', '$']

        edges << va_edge
      end

      edges.each do |derived_edge|

        # check derive from original attribution edge?
        derived_edge.source_navigable = true
        derived_edge.target_navigable = true

        # derived_edge.target_browse = node.browse?
        # derived_edge.target_index = node.index?

        model.add_edge(derived_edge)
      end

      # workaround for *1 above
      @@handled << node.name
      #

    end

    def ___match(node)

      return unless node.attribute?
      return unless node.data_type.eql?(:string_enumeration)
      if node.in_edges.empty?
        fail "-- error: attribute #{node.name} seems to have no inbound edges"
      end
      return if node.in_edges.first.forced?

      # caution name collisions possible
      name = node.name.camelize + 'Element'

      if model.element_exists?(name)
        puts "-- info: #{name} already exists, will use it"

        enumeration = model.detect(name)
      else
        enumeration = VirtualEnumerationType.new(name)
        model.add_node(enumeration)

        edges = []
        # check not added to model
        attribute_constant = VirtualAttribute.new('constant', :string)
        attribute_constant.browse = node.browse?
        attribute_constant.index = node.index?
        edges << VirtualAttributionEdge.new(enumeration, attribute_constant)

        attribute_name_de = VirtualAttribute.new('name_de', :string)
        attribute_name_de.browse = node.browse?
        attribute_name_de.index = node.index?

        # experimental
        attribute_name_de.secure = false

        edges << VirtualAttributionEdge.new(enumeration, attribute_name_de)

        edges.each do |derived_edge|

          # todo derive from original attribution edge?
          derived_edge.source_navigable = true
          derived_edge.target_navigable = true

          # derived_edge.target_browse = node.browse?
          # derived_edge.target_index = node.index?

          model.add_edge(derived_edge)
        end
      end

      node.in_edges.each do |in_edge|
        next unless in_edge.attribution?

        aggregation =
          case in_edge.target_end.literal_cardinality
          when :one
            edge = VirtualManyToOneAggregation.new(in_edge.source_end.client, enumeration)
            edge.target_multiplicity = node.required? ? [1,1] : [0,1]
            edge

          when :more
            edge = VirtualManyToManyAggregation.new(in_edge.source_end.client, enumeration)
            edge.target_multiplicity = node.required? ? [1,:*] : [0,:*]
            edge

          else
            fail '-- error: multiplicity error ' \
                   "for enumeration attribute #{in_edge.target_client.name} " \
                   "at concept #{in_edge.source_client.name}"

          end

        aggregation.source_multiplicity = [0,:*]

        # use settings from attribution edge
        # consider using #from(edge) method

        # enumeration elements are always re-used
        aggregation.target_builds_associated = false
        aggregation.target_links_associated = true

        # copy role name information from attribution edge
        # assume first in-edge is attribution edge
        aggregation.target_role_name = node.in_edges.first.target_role_name

        aggregation.source_navigable = true
        aggregation.target_navigable = true

        aggregation.target_browse = node.browse?
        aggregation.target_index = node.index?

        # note hide here, else edge_rebound in Attribute breaks!
        in_edge.hide!

        model.add_edge(aggregation)

        # copy position information
        # assume first in-edge is attribution edge
        original_position = node.in_edges.first.target_end.volatiles[:position]
        aggregation.target_end.volatiles[:position] = original_position

      end

      @result = enumeration
    end

  end

end