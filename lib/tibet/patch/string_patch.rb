
class String

  def singularize
    ActiveSupport::Inflector.singularize(self)
  end

  def pluralize
    ActiveSupport::Inflector.pluralize(self)
  end

  # 'camelCase' vs. 'PascalCase'
  # todo: add #pascalize method
  def camelize
    ActiveSupport::Inflector.camelize(self)
  end

  def underscore
    ActiveSupport::Inflector.underscore(self)
  end

  def hyphenize
    underscore.gsub('_', '-')
  end

  def blankize
    underscore.gsub('_', ' ')
  end

end