
require_relative '../lib/tibet'

model = Tibet::TibetProvider.model('../data/schema')
Tibet::TibetConsole.new(model).run