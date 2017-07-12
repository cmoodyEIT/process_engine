class ProcessEngine::JoinedInstance < ActiveRecord::Base
  belongs_to :first_active_record,  polymorphic: true
  belongs_to :second_active_record, polymorphic: true

end
