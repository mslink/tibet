
module Tibet

  class TransitiveAssociationDetectionRefinement < ElementRefinement

    def process

      # todo *1 check hiding connector edges

      model.entity_types.each do |entity_type|

        c1 = entity_type
               .in_edges
               .select(&:visible?)
               .select(&:association?) # semantics connector edges are visible! *1
               .one? { |e| e.target_end.transitive? }

        c2 = entity_type
               .out_edges
               .select(&:visible?)
               .any? { |e| e.target_end.transitive? }

        next unless c1 && c2

        left_participant =
          entity_type
            .in_edges
            .select(&:visible?)
            .select(&:association?) # semantics connector edges are visible! *1
            .detect { |e| e.target_end.transitive? }

        right_participants =
          entity_type
            .out_edges
            .select(&:visible?)
            .select { |e| e.target_end.transitive? }

        association = TransitiveAssociation.new(left_participant, right_participants)

        ([left_participant] + right_participants).each do |participant|
          participant.volatiles[:overlays] ||= {}
          participant.volatiles[:overlays][:transitive] = association
        end

      end

    end

  end

end