
module Tibet

  module EdgeModifierSupport

    # refactor ==> OK !
    # direct arc-access not recommended
    # instead: direct access to *annotation methods, which can be overridden in #VirtualEdgeSupport
    # see ***1 in #Edge
    # DISADVANTAGE: modifier cannot be set directly anymore, only via artificial *annotations
    #
    # NOTE
    # clear modifiers: method-based vs. annotation-simulation-based (see #suggest)

    def source_links_associated
      _links_associated?(source_annotations)
    end

    def target_links_associated
      _links_associated?(target_annotations)
    end

    def source_builds_associated
      _builds_associated?(source_annotations)
    end

    def target_builds_associated
      _builds_associated?(target_annotations)
    end

    def source_internal
      _internal?(source_annotations)
    end

    def target_internal
      _internal?(target_annotations)
    end

    def source_secure
      _secure?(source_annotations)
    end

    def target_secure
      _secure?(target_annotations)
    end

    def source_final
      _final?(source_annotations)
    end

    def target_final
      _final?(target_annotations)
    end

    def source_nesting
      _nesting?(source_annotations)
    end

    def target_nesting
      _nesting?(target_annotations)
    end

    def source_non_nesting
      _non_nesting?(source_annotations)
    end

    def target_non_nesting
      _non_nesting?(target_annotations)
    end

    def source_owner_property
      _owner_property?(source_annotations)
    end

    def target_owner_property
      _owner_property?(target_annotations)
    end

    def source_unique
      _unique?(source_annotations)
    end

    def target_unique
      _unique?(target_annotations)
    end

    def source_ordered
      _ordered?(source_annotations)
    end

    def target_ordered
      _ordered?(target_annotations)
    end

    def source_browse
      _browse?(source_annotations)
    end

    def target_browse
      _browse?(target_annotations)
    end

    def source_index
      _index?(source_annotations)
    end

    def target_index
      _index?(target_annotations)
    end

    def source_marker?(spec)
      _marker?(source_annotations, spec)
    end

    def target_marker?(spec)
      _marker?(target_annotations, spec)
    end

    def source_markers?(spec)
      _markers?(source_annotations, spec)
    end

    def target_markers?(spec)
      _markers?(target_annotations, spec)
    end

    ####

    private

    def _links_associated?(annotations)
      annotations.detect {|candidate| candidate =~ links_associated_pattern}
    end

    def _builds_associated?(annotations)
      annotations.detect {|candidate| candidate =~ builds_associated_pattern}
    end

    # value is assigned internally
    def _internal?(annotations)
      annotations.detect {|candidate| candidate =~ internal_pattern}
    end

    def _secure?(annotations)
      annotations.detect {|candidate| candidate =~ secure_pattern}
    end

    def _nesting?(annotations)
      !!annotations.detect {|candidate| candidate =~ nesting_pattern}
    end

    def _non_nesting?(annotations)
      !!annotations.detect {|candidate| candidate =~ non_nesting_pattern}
    end

    def _final?(annotations)
      annotations.detect {|candidate| candidate =~ final_pattern}
    end

    # todo rename to ownership
    def _owner_property?(annotations)
      annotations.detect {|candidate| candidate =~ owner_property_pattern}
    end

    def _unique?(annotations)
      annotations.detect {|candidate| candidate =~ unique_modifier_pattern}
    end

    def _ordered?(annotations)
      annotations.detect {|candidate| candidate =~ ordered_modifier_pattern}
    end

    def _browse?(annotations)
      annotations.detect {|candidate| candidate =~ browse_pattern}
    end

    def _index?(annotations)
      annotations.detect {|candidate| candidate =~ index_pattern}
    end

    # clone to #MarkerSupport
    # detects single marker occurrence
    # spec is a lambda function
    def _marker?(annotations, spec)
      match = annotations.detect{|candidate| spec[candidate]}
      spec[match] if match
    end

    # selects multiple occurrences
    # spec is a lambda function
    def _markers?(annotations, spec)
      annotations.select{|candidate| spec[candidate]}.map{|candidate| spec[candidate]}
    end
    # /clone

    ####

    # check modifier inversion (![modifier(x0)] => [modifier](x1..xn))

    def links_associated_pattern
      /L/
    end

    def builds_associated_pattern
      /B/
    end

    # internal properties are set within the system
    # boundary (server-side), never client-side
    def internal_pattern
      /I/
    end

    def secure_pattern
      /S/
    end

    def nesting_pattern
      /N/
    end

    def non_nesting_pattern
      /!N/
    end

    def final_pattern
      /F/
    end

    def owner_property_pattern
      /O/
    end

    def unique_modifier_pattern
      /\{u\}/
    end

    def ordered_modifier_pattern
      /\{o\}/
    end

    def browse_pattern
      /\+/
    end

    def index_pattern
      /\$/
    end

    def ___filter_pattern
      /%/
    end

  end

end