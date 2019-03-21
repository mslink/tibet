
module Tibet

# note
# What is polymorphic?
#
# An association is polymorphic, iff the result of its navigation may contain
# objects of different types. If this applies to only one direction, we qualify
# it as uni-polymorphic. If this applies to both directions, we qualify it as
# bi-polymorphic.

  class PolymorphicAssociation < ModelOverlay

    attr_reader :members

    def initialize(members, by_group)
      super()

      @members = members
      @by_group = by_group
    end

    def by_group?
      @by_group
    end

    def interface_name
      members.first.target_end.polymorphic_group_name + '_if'
    end

  end

end