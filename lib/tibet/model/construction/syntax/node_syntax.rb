
module Tibet

  module NodeSyntax

    def _check_name(refinement)
      rf = refinement

      assumed_name = rf.vertex.annotations.first
      unless assumed_name
        puts "-- error: entity type name not found: #{rf.vertex} (@#{rf.vertex.qualified_id})"
      end

      assumed_name
    end

    def check_class_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('entityRelationship.small_entity')
      valid_border = rf.vertex.double_border?
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      valid_type && valid_border && valid_label_font_style
    end

    def check_entity_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('entityRelationship.small_entity')
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      valid_type && valid_label_font_style
    end

    def check_module_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('flowchart.loopLimit')
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      valid_type && valid_label_font_style
    end

    def check_query_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('flowchart.predefinedProcess')
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      valid_type && valid_label_font_style
    end

    def check_relationship_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('flowchart.preparation')
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      valid_type && valid_label_font_style
    end

    def check_enumeration_type_node(refinement)
      rf = refinement

      assumed_name = _check_name(refinement)

      valid_type = rf.vertex.type.eql?('flowchart.storedData')
      valid_label_font_style = !rf.vertex.label_italic?(assumed_name)

      if valid_type && valid_label_font_style
        puts "-- enumeration type found @ #{assumed_name}"
      end

      valid_type && valid_label_font_style
    end

    ####

    def check_attribute_node(refinement)
      rf = refinement
      rf.vertex.type.eql?('entityRelationship.attribute')
    end

    def check_constraint_node(refinement)
      rf = refinement
      rf.vertex.type.eql?('flowchart.annotation')
    end

    def check_edge_connector_node(refinement)
      rf = refinement
      rf.vertex.type.eql?('rectangle')
    end

  end

end