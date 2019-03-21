
module Tibet

  class PolymorphicAssociationDetectionRefinement < ElementRefinement

    def process
      process_uni_polymorphic
    end

    def process_uni_polymorphic
      process_abstract
      process_group
    end

    def process_abstract
      model.edges.select(&:association?).each do |association|

        d1 = association.source_end.client.class?
        d2 = association.target_end.client.class?

        # use (d1 || d2) && create_polymorphic_association([association])
        if d1 || d2
          create_polymorphic_association([association])
        end
      end
    end

    def process_group
      model.entity_types.each do |entity_type|

        # a group is a collection of all edges having the
        # polymorphic role name in common
        groups =
          entity_type.in_edges
            .select(&:visible?)
            .select(&:association?)
            .select { |association| association.target_end.has_polymorphic_group_name? }
            .group_by { |association| association.target_end.polymorphic_group_name }

        groups.each do |_, members|

          puts "-- assuming polymorphic group: #{_}"

          # ignore pattern, iff member clients
          # originated from enumeration transformation
          members.reject!{|member| member.source_end.client.enumeration?}

          # unite members in polymorphic association
          unless members.empty?
            create_polymorphic_association(members, true)
          end
        end
      end
    end

    def create_polymorphic_association(members, by_group = false)
      members.each do |member|
        member.volatiles[:overlays] ||= {}

        polymorphic = PolymorphicAssociation.new(members, by_group)
        member.volatiles[:overlays][:polymorphic] = polymorphic
      end
    end

  end

end