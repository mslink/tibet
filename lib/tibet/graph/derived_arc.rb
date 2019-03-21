
module Tibet

  class DerivedArc < Arc

    attr_reader :source_part,
                :target_part,
                :center_parts

    LINE_STYLE = 'line'.freeze
    BLACK_COLOR = '#000000'.freeze

    def initialize(source_part, target_part, center_parts)
      super(nil, nil)

      @source_part = source_part
      @target_part = target_part
      @center_parts = center_parts
    end

    def qualified_source_id
      source_part.qualified_source_id
    end

    def qualified_target_id
      target_part.qualified_target_id
    end

    def source_arrow
      source_part.source_arrow
    end

    def target_arrow
      target_part.target_arrow
    end

    def source_annotation_nodes
      source_part.source_annotation_nodes
    end

    def target_annotation_nodes
      target_part.target_annotation_nodes
    end

    def center_annotation_nodes
      center_parts
        .map(&:center_annotation_nodes)
        .flatten
    end

    def color
      BLACK_COLOR
    end

    def style
      LINE_STYLE
    end

  end

end