module ProcessEngine
  class Instance < ApplicationRecord
    extend ProcessEngine::Schema
    extend ProcessEngine::Reflection
    # TODO: place holder for roles
    def self.roles() [] end
  end
end
