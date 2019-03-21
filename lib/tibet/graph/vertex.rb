
module Tibet

  class Vertex < GraphElement

    def type
      # assume node is a default ER node
      nodes = elements('data//y:GenericNode')
      unless nodes.empty?
        return nodes.first.attributes['configuration'].split('com.yworks.').last
      end

      # assume node is a shape node
      nodes = elements('data//y:ShapeNode')
      unless nodes.empty?
        return nodes.first.elements.to_a('y:Shape').first.attributes['type']
      end

      # assume node is a UML node
      elements('data').last.elements.to_a('*').first.name
    end

    def annotations
      elements(xpath_label).map(&:text)
    end

    def label_bold?(content)
      label_decorated?(content, 'fontStyle', 'bold') || label_bold_italic?(content)
    end

    def label_italic?(content)
      label_decorated?(content, 'fontStyle', 'italic') || label_bold_italic?(content)
    end

    def label_bold_italic?(content)
      label_decorated?(content, 'fontStyle', 'bolditalic')
    end

    def label_underlined?(content)
      label_decorated?(content, 'underlinedText', 'true')
    end

    def single_border?
      elements("data//y:StyleProperties//y:Property[@name='doubleBorder']").empty?
    end

    def double_border?
      es = elements("data//y:StyleProperties//y:Property[@name='doubleBorder']")
      !es.empty? && es.first.attributes['value'].eql?('true')
    end

    def dashed_border?
      # implement
    end

    def style
      elements('data//y:BorderStyle').first.attributes['type']
    end

    def color
      elements('data//y:BorderStyle').first.attributes['color']
    end

    def cartesian_y
      Float(elements('data//y:Geometry').first.attributes['y'])
    end

    private

    def label_decorated?(content, attribute, value)
      elements(xpath_label).one? { |label| label.text.eql?(content) && label.attributes[attribute].eql?(value) }
    end

    def xpath_label
      'data//y:NodeLabel'
    end

  end

end