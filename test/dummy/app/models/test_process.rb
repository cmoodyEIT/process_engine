class TestProcess < ProcessEngine::Instance
  has_columns(
    text:     {type: :text},
    string:   {type: :string},
    float:    {type: :float},
    integer:  {type: :integer},
    boolean:  {type: :boolean},
    date:     {type: :date},
    time:     {type: :time}
  )
end
