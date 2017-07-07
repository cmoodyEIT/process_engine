class ProcessEngine::JoinedInstance < ActiveRecord::Base
  belongs_to :first_active_record,  polymorphic: true
  belongs_to :second_active_record, polymorphic: true
  before_save :set_class_names
  def set_class_names
    self.first_active_record_class =  first_active_record.try(:class_name)
    self.second_active_record_class = second_active_record.try(:class_name)
  end

end
