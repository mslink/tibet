
module Tibet

  module HyperEdgeSupport

    def has_hyper_edges?
      (hyper_in_edges + hyper_out_edges).count > 0
    end

    def hyper_in_edges
      edge_connectors
        .map(&:in_edges)
        .flatten
        .reject(&:connector_edge?)
    end

    def hyper_out_edges
      edge_connectors
        .map(&:out_edges)
        .flatten
        .reject(&:connector_edge?)
    end

  end

end