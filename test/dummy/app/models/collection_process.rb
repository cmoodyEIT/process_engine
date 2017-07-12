class CollectionProcess < ActiveProcess::Instance
  has_and_belongs_to_many :test_processes
  has_many :belonging_processes
  has_one  :a_process, inverse_of: :parent_process, class_name: 'BelongingProcess'
end
