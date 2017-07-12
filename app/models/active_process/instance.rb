module ActiveProcess
  class Instance < ApplicationRecord
    extend ActiveProcess::Schema
    extend ActiveProcess::Reflection
    # TODO: place holder for roles
    def self.roles() [] end
  end
end
