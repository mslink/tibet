
module Tibet

  class Arc < GraphElement

    attr_accessor :edge_connectors

    def initialize(*args)
      super

      @edge_connectors = []
    end

    def qualified_source_id
      ns_prefix + xml_element.attributes['source']
    end

    def qualified_target_id
      ns_prefix + xml_element.attributes['target']
    end

    def source_arrow
      arrows.first.attributes['source']
    end

    def target_arrow
      arrows.first.attributes['target']
    end

    def arrows
      elements('data//y:Arrows')
    end

    ####

    # note: not available on all edge structures
    def points
      elements('data//y:PolyLineEdge//y:Path//y:Point')
    end

    # fix modifier rescue
    def cartesian_y
      Float(points.first['y']) rescue nil
    end

    ####

    def center_label_attribute_value(content)
      label_attribute_value(center_annotation_nodes, content, 'y')
    end

    def label_attribute_value(annotation_nodes, content, attribute)
      candidate = annotation_nodes.detect{|label| label.text.eql?(content)}
      candidate[attribute] if candidate
    end

    # bold

    def source_label_bold?(content)
      source_label_decorated?(content, 'fontStyle', 'bold') || source_label_bold_italic?(content)
    end

    def target_label_bold?(content)
      target_label_decorated?(content, 'fontStyle', 'bold') || target_label_bold_italic?(content)
    end

    def center_label_bold?(content)
      center_label_decorated?(content, 'fontStyle', 'bold') || center_label_bold_italic?(content)
    end

    # italic

    def source_label_italic?(content)
      source_label_decorated?(content, 'fontStyle', 'italic') || source_label_bold_italic?(content)
    end

    def target_label_italic?(content)
      target_label_decorated?(content, 'fontStyle', 'italic') || target_label_bold_italic?(content)
    end

    def center_label_italic?(content)
      center_label_decorated?(content, 'fontStyle', 'italic') || center_label_bold_italic?(content)
    end

    # bold italic

    def source_label_bold_italic?(content)
      source_label_decorated?(content, 'fontStyle', 'bolditalic')
    end

    def target_label_bold_italic?(content)
      target_label_decorated?(content, 'fontStyle', 'bolditalic')
    end

    def center_label_bold_italic?(content)
      center_label_decorated?(content, 'fontStyle', 'bolditalic')
    end

    # underlined

    def source_label_underlined?(content)
      source_label_decorated?(content, 'underlinedText', 'true')
    end

    def target_label_underlined?(content)
      target_label_decorated?(content, 'underlinedText', 'true')
    end

    def center_label_underlined?(content)
      center_label_decorated?(content, 'underlinedText', 'true')
    end

    ####

    def source_annotation_nodes
      elements(xpath_source_label)
    end

    def target_annotation_nodes
      elements(xpath_target_label)
    end

    def center_annotation_nodes
      elements(xpath_center_label)
    end

    ####

    def source_annotations
      source_annotation_nodes.map(&:text)
    end

    def target_annotations
      target_annotation_nodes.map(&:text)
    end

    def center_annotations
      center_annotation_nodes.map(&:text)
    end

    ####

    def style
      elements('data//y:LineStyle').first.attributes['type']
    end

    def color
      elements('data//y:LineStyle').first.attributes['color']
    end

    private

    def source_label_decorated?(content, attribute, value)
      label_decorated?(source_annotation_nodes, content, attribute, value)
    end

    def target_label_decorated?(content, attribute, value)
      label_decorated?(target_annotation_nodes, content, attribute, value)
    end

    def center_label_decorated?(content, attribute, value)
      label_decorated?(center_annotation_nodes, content, attribute, value)
    end

    ####

    def label_decorated?(annotation_nodes, content, attribute, value)
      annotation_nodes.one?{|label| label.text.eql?(content) && label.attributes[attribute].eql?(value)}
    end

    def xpath_source_label
      'data//y:EdgeLabel[@preferredPlacement="source"]'
    end

    def xpath_target_label
      'data//y:EdgeLabel[@preferredPlacement="target"]'
    end

    def xpath_center_label
      'data//y:EdgeLabel[@preferredPlacement="center"]'
    end

  end

end