class TestProcess < ProcessEngine::Instance
  has_and_belongs_to_many :collection_processes
  has_columns(
    text:     {type: :text},
    string:   {type: :string},
    float:    {type: :float},
    integer:  {type: :integer},
    boolean:  {type: :boolean},
    date:     {type: :date},
    time:     {type: :date_time}
  )
end
