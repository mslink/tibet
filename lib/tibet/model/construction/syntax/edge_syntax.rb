
module Tibet

  module EdgeSyntax

    def check_attribution_edge(refinement)
      rf = refinement

      if rf.target_arrow.eql?('none')
        # assuming attribute edge

        unless rf.style.eql?('line')
          return false
        end

        unless rf.source_node.type?
          # puts 'invalid source type for attribute edge: ' \
          #      "#{rf.source_node} (@#{rf.source_node.qualified_id})"

          return false
        end

        unless rf.target_node.attribute?
          # puts 'invalid target type for attribute edge: ' \
          #      "#{rf.target_node} (@#{rf.target_node.qualified_id})"

          return false
        end

        true
      end

    end

    ####

    def check_association_edge(refinement)
      _check_association_edge(refinement, 'none')
    end

    def check_aggregation_edge(refinement)
      _check_association_edge(refinement, 'white_diamond')
    end

    def check_composition_edge(refinement)
      _check_association_edge(refinement, 'diamond')
    end

    def _check_association_edge(refinement, source_arrow)
      rf = refinement

      # check early detection
      unless rf.source_node && rf.target_node
        abort '-- error: edge not mounted; check usage of invalid language features'
      end

      # note
      # non-navigability on source cannot be set for aggregation resp. composition

      if rf.source_arrow.eql?(source_arrow) || rf.source_arrow.eql?('skewed_dash')
        # assuming association edge

        d1 = rf.target_arrow.eql?('none')
        d2 = rf.target_arrow.eql?('standard')
        d3 = rf.target_arrow.eql?('transparent_circle')
        d4 = rf.target_arrow.eql?('skewed_dash')
        d5 = rf.target_arrow.eql?('dash')
        d6 = rf.target_arrow.eql?('t_shape')
        d7 = rf.target_arrow.eql?('short')

        unless d1 || d2 || d3 || d4 || d5 || d6 || d7
          return false
        end

        unless rf.source_node.type?
          # puts 'invalid source type for association edge: ' \
          #      "#{rf.source_node} (@#{rf.source_node.qualified_id})"

          return false
        end

        unless rf.target_node.type?
          # puts 'invalid target type for association edge: ' \
          #      "#{rf.target_node} (@#{rf.target_node.qualified_id})"

          return false
        end

        true
      end

    end

    ####

    def check_classification_edge(refinement)
      rf = refinement

      if rf.target_arrow.eql?('plain')
        # assuming classification edge

        unless rf.source_node.type?
          puts 'invalid source type for classification edge: ' \
             "#{rf.source_node} (@#{rf.source_node.qualified_id})"

          return false
        end

        unless rf.target_node.class?
          puts 'invalid target type for classification edge: ' \
             "#{rf.target_node} (@#{rf.target_node.qualified_id})"

          return false
        end

        true
      end

    end

    ####

    # inclusion
    def check_inclusion_edge(refinement)
      rf = refinement

      if rf.target_arrow.eql?('white_delta')
        # assuming inclusion edge

        unless rf.source_node.concrete? || (true)
          puts 'invalid source type for inclusion edge: ' \
             "#{rf.source_node} (@#{rf.source_node.qualified_id})"

          return false
        end

        unless rf.target_node.concrete? || (true)
          puts 'invalid target type for inclusion edge: ' \
             "#{rf.target_node} (@#{rf.target_node.qualified_id})"

          return false
        end

        true
      end

    end

    ####

    def check_restriction_edge(refinement)
      rf = refinement

      if rf.target_arrow.eql?('concave')
        # assuming restriction edge

        unless rf.source_node.attribute?
          puts 'invalid source type for restriction edge: ' \
             "#{rf.source_node} (@#{rf.source_node.qualified_id})"

          return false
        end

        unless rf.target_node.constraint? || rf.target_node.attribute?
          puts 'invalid target type for restriction edge: ' \
             "#{rf.target_node} (@#{rf.target_node.qualified_id})"

          return false
        end

        true
      end

    end

    ####

    def check_semantic_edge(refinement)
      rf = refinement

      c1 = rf.source_node.edge_connector? && rf.target_node.edge_connector?
      c2 = rf.source_node.type?           && rf.target_node.type?
      c3 = rf.source_node.edge_connector? && rf.target_node.type?

      c4 = rf.source_arrow.eql?('none') && rf.target_arrow.eql?('convex')

      (c1 && c4) || (c2 && c4) || (c3 && c4)
    end

    ####

    def check_supply_edge(refinement)
      rf = refinement

      d10 = rf.source_node.entity? && ( rf.target_node.entity? || rf.target_node.class? || rf.target_node.relationship? )
      d20 = rf.source_node.class? && ( rf.target_node.entity? || rf.target_node.class? )
      d25 = rf.source_node.module? && ( rf.target_node.entity? || rf.target_node.class? )

      c30 = rf.source_arrow.eql?('none') && rf.target_arrow.eql?('circle')

      (d10 || d20 || d25) && c30
    end

    ####

    def check_connector_edge(refinement)
      rf = refinement

      c1 = rf.source_node.type? || rf.source_node.edge_connector?
      c2 = rf.target_node.type? || rf.target_node.edge_connector?

      # note
      # does not cover all edge types yet

      ds = []

      ds << (rf.source_arrow.eql?('none')          && rf.target_arrow.eql?('none'))
      ds << (rf.source_arrow.eql?('white_diamond') && rf.target_arrow.eql?('none'))
      ds << (rf.source_arrow.eql?('diamond')       && rf.target_arrow.eql?('none'))

      ds << (rf.source_arrow.eql?('none')          && rf.target_arrow.eql?('standard'))
      ds << (rf.source_arrow.eql?('white_diamond') && rf.target_arrow.eql?('standard'))
      ds << (rf.source_arrow.eql?('diamond')       && rf.target_arrow.eql?('standard'))

      ds << (rf.source_arrow.eql?('none')          && rf.target_arrow.eql?('transparent_circle'))
      ds << (rf.source_arrow.eql?('white_diamond') && rf.target_arrow.eql?('transparent_circle'))
      ds << (rf.source_arrow.eql?('diamond')       && rf.target_arrow.eql?('transparent_circle'))

      c3 = ds.one?

      c1 && c2 && c3
    end

  end

end