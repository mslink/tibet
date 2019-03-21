
module Tibet

  class AssociationRefinement < ArcRefinement

    def match(arc)
      super

      if valid?
        @result = Association.new(arc, source_node, target_node)
      end

    end

  end

end