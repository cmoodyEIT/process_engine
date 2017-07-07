class CollectionProcess < ProcessEngine::Instance
  has_and_belongs_to_many :test_processes
end
