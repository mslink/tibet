
class Symbol

  def singularize
    to_s.singularize.to_sym
  end

  def pluralize
    to_s.pluralize.to_sym
  end

  def camelize
    to_s.camelize.to_sym
  end

  def underscore
    to_s.underscore.to_sym
  end

  def hyphenize
    to_s.hyphenize.to_sym
  end

  def blankize
    to_s.blankize.to_sym
  end

end