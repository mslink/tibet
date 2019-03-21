
module Tibet

  class ConstraintSpecializationRefinement < ElementRefinement

    def match(node)

      return unless node.constraint?

      # note repeated execution protection
      # return if node.volatiles.dig(self.class, :done)
      # node.volatiles[self.class][:done] = true

      @result =
        case node.type
        when :inclusion
          InclusionConstraint.new(node)

        when :exclusion
          ExclusionConstraint.new(node)

        when :format
          FormatConstraint.new(node)

        when :interval
          IntervalConstraint.new(node)

        else
          abort "-- error: constraint specialization error (@#{node.qualified_id})"

        end

      # mount/replace
      all_in_edges = node.in_edges.select(&:visible?)
      all_out_edges = node.out_edges.select(&:visible?)

      cloned_in_edges = all_in_edges.map(&:clone)
      cloned_out_edges = all_out_edges.map(&:clone)

      cloned_in_edges.each do |in_edge|
        @result.add_in_edge(in_edge)
        in_edge.target_end.change_client(@result)
        model.add_edge(in_edge)
      end

      cloned_out_edges.each do |out_edge|
        @result.add_out_edge(out_edge)
        out_edge.source_end.change_client(@result)
        model.add_edge(out_edge)
      end

      all_in_edges.each(&:hide!)
      all_out_edges.each(&:hide!)

    end

  end

end