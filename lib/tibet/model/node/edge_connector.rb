
module Tibet

  class EdgeConnector < ActualNode

    attr_accessor :base

    def edge_connector?
      true
    end

    def contact_point?
      source_contact_point? || target_contact_point?
    end

    def source_contact_point?
      in_edges.select(&:connector_edge?).detect {|e| e.source_client.type?}
    end

    def target_contact_point?
      out_edges.select(&:connector_edge?).detect {|e| e.target_client.type?}
    end

    def neighbours(neighbours = [])
      in_edges
        .select(&:connector_edge?)
        .select {|in_edge| in_edge.source_client.edge_connector?}
        .reject {|in_edge| neighbours.include?(in_edge.source_client)}
        .each {|in_edge| neighbours << in_edge.source_client}
        .each {|in_edge| in_edge.source_client.neighbours(neighbours)}

      out_edges
        .select(&:connector_edge?)
        .select {|out_edge| out_edge.target_client.edge_connector?}
        .reject {|out_edge| neighbours.include?(out_edge.target_client)}
        .each {|out_edge| neighbours << out_edge.target_client}
        .each {|out_edge| out_edge.target_client.neighbours(neighbours)}

      neighbours << self if neighbours.empty?

      neighbours
    end

  end

end