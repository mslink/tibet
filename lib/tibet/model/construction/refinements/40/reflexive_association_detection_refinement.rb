
module Tibet

  class ReflexiveAssociationDetectionRefinement < ElementRefinement

    def process
      process_direct_reflexiveness
      process_indirect_reflexiveness
    end

    def process_direct_reflexiveness
      model.edges.select(&:association?).each do |association|
        association.source_end.client.eql?(association.target_end.client) && create_reflexive_association(association)
      end
    end

    def process_indirect_reflexiveness

      model.entity_types.each do |entity_type|
        set_a = entity_type.out_associations
        set_b = entity_type.out_classifications

        set_i = set_a.select do |association|
          set_b.map(&:target_end).map(&:client).include?(association.target_end.client)
        end

        set_i.each do |association|
          create_reflexive_association(association)
        end

      end

    end

    def create_reflexive_association(association)
      puts "-- reflexive association found @ #{association}"

      association.volatiles[:overlays] ||= {}
      reflexive = ReflexiveAssociation.new
      association.volatiles[:overlays][:reflexive] = reflexive
    end

  end

end