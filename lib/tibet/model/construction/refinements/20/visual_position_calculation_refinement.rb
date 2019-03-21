
module Tibet

  class VisualPositionCalculationRefinement < ElementRefinement

    def process

      model.type_nodes.each do |node|

        deltas = node.out_edges.map do |edge|
          # [edge.target_end, edge.target_end.client.cartesian_y - node.cartesian_y]

          # experimental
          [
            edge.target_end,
            (edge.cartesian_y || edge.target_end.client.cartesian_y) - node.cartesian_y
          ]

        end.compact

        deltas
          .sort_by { |t| t[1] }
          .each_with_index { |(endpoint, delta), i|
            endpoint.volatiles[:position] = i
            endpoint.volatiles[:delta] = delta
          }

        # .map(&:first)

      end

    end

  end

end