
module Tibet

  class TypeUnificationRefinement < ElementRefinement

    def process

      groups = model.type_nodes.group_by(&:name)

      groups.each do |name, occurrences|

        if occurrences.count > 1
          occurrences.each(&:hide!)

          original_in_edges = occurrences.map do |occurrence|
            occurrence.in_edges.select(&:visible?)
          end.flatten

          original_out_edges = occurrences.map do |occurrence|
            occurrence.out_edges.select(&:visible?)
          end.flatten

          # intersect to get reflexive edges
          original_reflexive_edges = original_in_edges & original_out_edges

          # remove reflexive (sub)set from in/out edge set
          original_in_edges = original_in_edges - original_reflexive_edges
          original_out_edges = original_out_edges - original_reflexive_edges

          cloned_in_edges = original_in_edges.map(&:clone)
          cloned_out_edges = original_out_edges.map(&:clone)
          cloned_reflexive_edges = original_reflexive_edges.map(&:clone)

          original_in_edges.each(&:hide!)
          original_out_edges.each(&:hide!)
          original_reflexive_edges.each(&:hide!)

          # refactor
          #
          unless occurrences.map(&:class).uniq.size.eql?(1)
            abort "-- error: unification error @#{name}, check for different language concepts with same name"
          end

          derived = nil

          if occurrences.all?(&:class?)
            derived = DerivedClassType.new(name, occurrences)
          end

          if occurrences.all?(&:entity?)
            derived = DerivedEntityType.new(name, occurrences)
          end

          if occurrences.all?(&:module?)
            derived = DerivedModuleType.new(name, occurrences)
          end

          if occurrences.all?(&:enumeration?)
            derived = DerivedEnumerationType.new(name, occurrences)
          end

          if occurrences.all?(&:query?)
            derived = DerivedQueryType.new(name, occurrences)
          end

          if occurrences.all?(&:relationship?)
            derived = DerivedRelationshipType.new(name, occurrences)
          end

          unless derived
            puts "-- error: problems with @ #{name}"
            puts occurrences
            abort '-- error: unification failed'
          end

          cloned_in_edges.each do |cloned_in_edge|
            cloned_in_edge.target_end.change_client(derived)
            model.add_edge(cloned_in_edge)
            derived.add_in_edge(cloned_in_edge)
          end

          cloned_out_edges.each do |cloned_out_edge|
            cloned_out_edge.source_end.change_client(derived)
            model.add_edge(cloned_out_edge)
            derived.add_out_edge(cloned_out_edge)
          end

          cloned_reflexive_edges.each do |cloned_reflexive_edge|
            cloned_reflexive_edge.source_end.change_client(derived)
            cloned_reflexive_edge.target_end.change_client(derived)
            model.add_edge(cloned_reflexive_edge)
            derived.add_out_edge(cloned_reflexive_edge)
            derived.add_in_edge(cloned_reflexive_edge)
          end

          model.add_node(derived)
        end
      end
    end

  end

end