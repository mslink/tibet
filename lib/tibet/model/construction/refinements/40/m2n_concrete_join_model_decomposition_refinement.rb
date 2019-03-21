
module Tibet

  class M2NConcreteJoinModelDecompositionRefinement < ElementRefinement

    def process

      # complete clone of M2NBiPolymorphicJoinModelDecompositionRefinement

      model.class_types.each do |class_type|

        edge_candidates = class_type
                            .in_edges
                            .select(&:visible?)
                            .select(&:many_to_many?)

        # check for m:n
        return unless edge_candidates

        source_clients = edge_candidates.map(&:source_client)

        unless source_clients.map(&:name).size.eql?(source_clients.map(&:name).uniq.size)
          abort "-- error: decomposition failed @ #{class_type}"
        end

        m2n_edges = edge_candidates

        m2n_edges.each do |many2n|
          source_client = many2n.source_client

          name = "Join#{source_client.name}#{class_type.name}"
          entity = VirtualEntityType.new(name)

          # check Virtual vs. Derived in Edge context

          # create one-to-many edge to new entity
          one2n_target = [VirtualOneToManyAssociation,
                          VirtualOneToManyAggregation,
                          VirtualOneToManyComposition]
                           .detect {|c| c.kind.eql?(many2n.kind)}

          one2n = one2n_target.new(many2n.source_end.client, entity)

          # derive role name
          one2n.source_role_name = many2n.source_role_name
          one2n.target_role_name = "#{many2n.target_role_name}_join_tuple"

          # the join model is always freshly built
          one2n.target_builds_associated = true

          # create many-to-one edge from new entity
          m2one_target = [VirtualManyToOneAssociation,
                          VirtualManyToOneAggregation]
                           .detect {|c| c.kind.eql?(many2n.kind)}

          m2one = m2one_target.new(entity, many2n.target_end.client)

          ####

          # puts "creating join model #{entity.name}"
          # puts "m2one: #{m2one}"
          # puts "one2n: #{one2n}"

          # set multiplicities
          one2n.target_multiplicity = [0,:*]
          m2one.target_multiplicity = [1,1]

          # make edges navigable
          # check construction: one2n.target_end.navigable would be more straightforward
          one2n.target_navigable = true
          one2n.source_navigable = true

          m2one.target_navigable = true
          m2one.source_navigable = true

          many2n.hide!

          model.add_node(entity)
          model.add_edge(one2n)
          model.add_edge(m2one)
        end

      end

    end

    def new_entity_name
      ['Join']
        .product(source_clients.map(&:name))
        .product([class_type.name])
        .map(&:flatten)
        .map(&:join)
    end

  end

end