
module Tibet

  class TransitiveAssociation < ModelOverlay

    attr_reader :left_participant,
                :right_participants

    def initialize(left_participant, right_participants)
      super()

      @left_participant = left_participant
      @right_participants = right_participants
    end

  end

end