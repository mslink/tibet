
module Tibet

  class GraphElement

    attr_reader :volatiles

    def initialize(namespace, xml_element)
      @namespace = namespace
      @xml_element = xml_element

      @volatiles = {}
    end

    # use attr_reader
    def namespace
      @namespace
    end

    # use attr_reader
    def xml_element
      @xml_element
    end

    def qualified_id
      ns_prefix + xml_element.attributes['id']
    end

    def reveal
      xml_element
    end

    private

    def ns_prefix
      "#{namespace}:"
    end

    def elements(path)
      xml_element.elements.to_a(path)
    end

  end

end