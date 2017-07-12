class BelongingProcess < ActiveProcess::Instance
  belongs_to :collection_process
  belongs_to :parent_process, inverse_of: 'a_process', class_name: 'CollectionProcess'
end
