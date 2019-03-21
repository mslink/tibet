
module Tibet

  class RelationshipType < EntityType

    # semantics
    # binary relationship: uniqueness, engaged, disengaged, toggle, etc. on RelationshipColonizer

    def concrete?
      true
    end

    def entity?
      false
    end

    def relationship?
      true
    end

    def parents(axes = [])
      super
    end

    def children(axes = [])
      super
    end

    # returns edge
    def left_participant
      in_associations.detect{|a| a.target_end.participant?}
    end

    # returns edge
    def right_participants
      spec = ->(annotation) {
        match = annotation.match(/\((\d*)\)/)

        if match
          index = match.captures.first
          index.empty? ? Float::INFINITY : Integer(index)
        else
          Float::INFINITY
        end
      }

      # caution
      # if no annotations are given, spec is not processed at all
      sorting = ->(e) {e.target_end.marker?(spec) || Float::INFINITY}

      out_associations
        .select{|a| a.target_end.participant?}
        .sort_by(&sorting)
    end

    def lowest_right_participant
      right_participants.first
    end

    def highest_right_participant
      right_participants.last
    end

    # returns edge client
    def left_member
      left_participant.target_end.client
    end

    # returns edge clients
    def right_members
      right_participants.map(&:target_end).map(&:client)
    end

    def lowest_right_member
      right_members.first
    end

    def highest_right_member
      right_members.last
    end

    #

    # note
    # used within entity compound structure
    # has no explicit participant markers
    # 'dependent'
    def weak?
      !left_participant && right_participants.empty?
    end

    # note
    # stands for itself
    # has explicit participant markers
    # 'independent'
    def strong?
      left_participant && !right_participants.empty?
    end

    # # # #

    # todo rating-example
    # in supply-context
    def producer
      right_participants.map(&:target_end)
        .detect{|endpoint| endpoint.marker?(->(a) {a =~ /\{p\}/})}&.client
    end

  end

end