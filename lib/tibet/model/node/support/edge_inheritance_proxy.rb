
module Tibet

  class EdgeInheritanceProxy

    # delegates with interception

    attr_reader :edge,
                :interim_client,
                :role

    def initialize(edge, interim_client, role)
      @edge = edge
      @interim_client = interim_client
      @role = role
    end

    #

    def ==(other)
      hash == other.hash
    end

    def eql?(other)
      self == other
    end

    # idem EdgeProxy vs. same EdgeProxy
    def hash
      [edge, interim_client, role].hash
    end

    #

    def method_missing(id, *args)
      unless edge.respond_to?(id)
        # puts "-- error: method #{id} not found on #{edge.class}"
        super
      end
      with_client_swapping {edge.send(id, *args)}
    end

    # interception
    def with_client_swapping

      if role.eql?(:source)
        original_client = edge.source_end.client
        edge.source_end.change_client(interim_client)
        result = yield
        edge.source_end.change_client(original_client)

        return result
      end

      if role.eql?(:target)
        original_client = edge.target_end.client
        edge.target_end.change_client(interim_client)
        result = yield
        edge.target_end.change_client(original_client)

        return result
      end

      fail '-- error: client swapping failed'
    end

    def to_s
      # "#{with_client_swapping {edge.to_s}} [inherited]"
      "#{with_client_swapping {edge.to_s}} []"
    end

  end

end