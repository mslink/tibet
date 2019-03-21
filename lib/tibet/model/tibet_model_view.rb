
module Tibet

  class TibetModelView

    attr_reader :model

    def initialize(model)
      @model = model
    end

    #

    def validate!
      model.validate!
    end

    def volatiles
      model.volatiles
    end

    #

    def add_node(*args)
      model.add_node(*args)
    end

    def nodes
      model.nodes.select(&:visible?)
    end

    def all_nodes
      model.nodes
    end

    def find_node_by_id(*args)
      model.find_node_by_id(*args)
    end

    #

    def add_edge(*args)
      model.add_edge(*args)
    end

    def edges
      model.edges.select(&:visible?)
    end

    def all_edges
      model.edges
    end

    #

    def type_nodes
      nodes.select(&:type?)
    end

    def abstract_types
      nodes.select(&:type?).select(&:abstract?)
    end

    def concrete_types
      nodes.select(&:type?).select(&:concrete?)
    end

    def class_types
      nodes.select(&:class?)
    end

    def module_types
      nodes.select(&:module?)
    end

    def entity_types
      nodes.select(&:entity?)
    end

    def enumeration_types
      nodes.select(&:enumeration?)
    end

    def relationship_types
      nodes.select(&:relationship?)
    end

    def query_types
      nodes.select(&:query?)
    end

    #

    def edge_connectors
      nodes.select(&:edge_connector?)
    end

    #

    def polymorphic_associations
      edges.select(&:polymorphic_member?)
    end

    def transitive_associations
      edges.select(&:transitive_member?)
    end

    #

    def finish!
      model.finish!
    end

    #

    def elements
      nodes + edges
    end

    #

    def detect(name)
      elements.detect{|e| e.name.eql?(name)}
    end
    alias element_exists? detect

    #

    def statistics
      model.statistics
    end

  end

end