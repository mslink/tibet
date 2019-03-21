
module Tibet

  class Attribute < ActualNode

    include MarkerSupport

    def attribute?
      true
    end

    # contract #MarkerSupport
    def annotations
      vertex.annotations
    end

    def native_name
      vertex.annotations.detect{|candidate| candidate =~ native_name_pattern}
    end

    def name
      if native_name

        if native_name.start_with?(' ')
          fail "-- error: invalid attribute name '#{native_name}', leading whitespace found"
        end

        if native_name.end_with?(' ')
          fail "-- error: invalid attribute name '#{native_name}', trailing whitespace found"
        end

        # remove computed attribute marker '/'
        # replace new line with space
        # replace space with underscore
        normalized_name = native_name.delete('/').gsub(/\n/, ' ').gsub(/ /, '_')

        $R.info "-- native attribute name #{native_name} was normalized to to #{normalized_name}"

        normalized_name
      else

        fail "-- error: invalid attribute name (@#{vertex.reveal})"
      end
    end

    def computed?
      native_name.start_with?('/')
    end

    # todo
    def default_value
      s = 'var=true'

      # note
      # '?:' is a non-capturing group, so '=value' can be optionally matched
      # and the '=' character will not appear in the captures

      s.match( /([a-z]*)(?:=(.*))?/ )
      # => #<MatchData "var=true" 1:"var" 2:"true">

      s.match( /([a-z]*)(?:=(.*))?/ ).captures
      # => ["var", "true"]
    end

    def data_type
      shortcut = vertex.annotations.detect{|candidate| candidate =~ data_type_pattern}

      # return string as default data type
      shortcut ? literal_type_of(shortcut.to_sym) : :string
    end
    alias :type :data_type

    def boolean?
      data_type.eql?(:boolean)
    end

    def restrictions
      out_edges
        .select(&:visible?)
        .select(&:restriction?)
    end

    def constraints
      restrictions
        .map(&:target_client)
        .select(&:constraint?)
    end

    def required?
      vertex.style.eql?('line') || unique?
    end

    def optional?
      vertex.style.eql?('dashed') && !unique?
    end

    def unique?
      vertex.label_underlined?(native_name)
    end

    # attribute does not enter or
    # leave system boundary
    def secure?
      vertex.double_border?
    end

    # attribute can be browsed
    def browse?
      endpoint_rebound.browse? || vertex.label_bold?(native_name)
    end

    # new
    def index?
      endpoint_rebound.index?
    end

    # attribute is exclusively assigned internally
    def internal?
      endpoint_rebound.internal?
    end

    # attribute does not change after initial assignment
    def final?
      endpoint_rebound.final?
    end

    def nesting?
      endpoint_rebound.nesting?
    end

    def non_nesting?
      endpoint_rebound.non_nesting?
    end

    # conceptual break
    def marker?(spec)
      endpoint_rebound.marker?(spec) || super
    end

    # reflexive modifier acquisition (via attribution edge)
    # for modifiers queried on attribute, but laying on the
    # attribution edge
    def endpoint_rebound
      edge.target_end
    end

    def edge
      in_edges
        .select(&:visible?)
        .select(&:attribution?)
        .first
    end

    # breaks if schema is linked more than one time
    # (under different name)
    # breaks if attribution edge is commented out
    # and attribute node is still active
    # breaks if there's no edge to attribute
    def owner
      # streamline
      unless edge&.source_client
        abort '-- error: check multiple symbolic linking / check attribution commented out / check edge to attribute'
      end

      edge.source_client
    end

    private

    def native_name_pattern
      /^\/?([a-z0-9_ ]+)$/
    end

    # available types (not completely supported yet)
    # * binary        #
    # * boolean       #
    # * date          #
    # * datetime      #
    # * decimal
    # * float         #
    # * integer       #
    # * primary_key
    # * references
    # * string        #
    # * text
    # * time          #
    # * timestamp
    #
    # see https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L75
    def literal_type_of(shortcut)

      # if shortcut.eql?(:T)
      #   puts '-- time type (T) will be handled via string type (S)'
      # end

      {
        S:  :string,
        # SE: :string_enumeration,

        I:  :integer,

        F:  :float,

        B:  :boolean,

        D:  :date,
        T:  :time,

        # T:  :string,

        DT: :datetime,

        L:  :blob,

        Y:  :type

      }[shortcut]

    end

    def data_type_pattern
      # /^(S|SE|I|F|B|D|T|DT|L|Y)$/
      /^(S|I|F|B|D|T|DT|L|Y)$/
    end

  end

end