class TestProcess < ActiveProcess::Instance
  has_and_belongs_to_many :collection_processes
  has_columns(
    text:      {type: :text},
    string:    {type: :string},
    float:     {type: :float},
    integer:   {type: :integer},
    boolean:   {type: :boolean},
    date:      {type: :date},
    time:      {type: :date_time},
    dependent: {type: :string, dependent: :text},
    depends:   {type: :string, dependent: :dependent_method}
  )
  def dependent_method
    float.present? && time.nil && date.present?
  end
end
