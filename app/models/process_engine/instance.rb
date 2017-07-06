module ProcessEngine
  class Instance < ApplicationRecord
    extend ProcessEngine::Schema
    # TODO: place holder for roles
    def self.roles() [] end
  end
end
