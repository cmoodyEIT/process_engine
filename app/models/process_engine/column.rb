class ProcessEngine::Column
  def initialize(name,options,parent)
    @name         = name
    @type         = options[:type] || :string
    @options      = options || {}
    @klass        = @type.to_s.classify.safe_constantize || String
    @class_module = parent
    setup_constant unless @klass < ActiveRecord::Base
    # setup_active(class_module,column_name,options,type,klass)       if klass < ActiveRecord::Base
    # class_module.send(:define_method,"#{column_name}_options") {options[:options]} if options[:options].present?
    # class_module.send(:define_method,"#{column_name}_type")    {options[:type] || :string}
  end
  def singular?() @type.to_s == @type.to_s.singularize end

  def setup_constant
    # @process_columns[column_name] = options
    # @inspector_fields << column_name
    singular? ? single_constant : multiple_constant
    # class_module.send(:define_method,"#{column_name}_view_type") {options[:type] || :string}
    # class_module.send(:define_method,"#{column_name}_options")   {options[:options]} if options[:options].present?
  end
  def single_constant
    current_name = @name.to_s
    @class_module.send(:define_method,"#{@name}") do
      arg = current_state[current_name]
      # arg.blank? ? arg : arg.send("to_#{type}")
    end
    @class_module.send(:define_method,"#{@name}_was") do
      arg = current_state_was[current_name]
      # arg.blank? ? arg : arg.send("to_#{type}")
    end
    @class_module.send(:define_method,"#{@name}=") do |arg|
      current_state[current_name] = arg#.present? ? arg.send("to_#{type}") : arg
    end
  end
  def multiple_constant
    # add_to_whitelist({column_name => []})
    # class_module.send(:define_method,"#{column_name}") do
    #   arg = current_state[column_name.to_s]
    #   arg.blank? ? [] : arg.map{|item| item.send("to_#{type.to_s.singularize}")}
    # end
    # class_module.send(:define_method,"#{column_name}_was") do
    #   arg = current_state_was[column_name.to_s]
    #   arg.blank? ? [] : arg.map{|item| item.send("to_#{type.to_s.singularize}")}
    # end
    # class_module.send(:define_method,"#{column_name}=") do |arg|
    #   current_state[column_name.to_s] = arg.present? ? arg.map{|item| item.send("to_#{type.to_s.singularize}")} : arg
    # end
  end
  # def setup_active(class_module,column_name,options,type,klass)
  #   add_to_whitelist("#{column_name}_id")
  #   ar_options = options.dup
  #   ar_options[:type] = :number
  #   ar_options[:ar_type] = klass.to_s
  #   # @process_columns["#{column_name}_id"] = ar_options
  #   class_module.send(:define_method,type.to_s.pluralize) {klass.all}
  #   # @inspector_fields << "#{column_name}_id"
  #   class_module.send(:define_method,"#{column_name}_id") do
  #     val = current_state["#{column_name}_id"]
  #     val.present? ? val.to_i : val
  #   end
  #   class_module.send(:define_method, "#{column_name}_id_was") do
  #     val = current_state_was["#{column_name}_id"]
  #     val.present? ? val.to_i : val
  #   end
  #   class_module.send(:define_method, "#{column_name}_id=") do |arg|
  #     current_state["#{column_name}_id"] = arg
  #   end
  #   class_module.send(:define_method, "#{column_name}=") do |arg|
  #     instance_variable_set("@#{column_name}",arg)
  #     send("#{column_name}_id=",arg.try(:id))
  #   end
  #   class_module.send(:define_method, column_name) do
  #     return nil unless (id = current_state["#{column_name}_id"]).present?
  #     current = instance_variable_get("@#{column_name}")
  #     if current.nil? || current.try(:id) != id
  #       current = klass.find(id)
  #       send("#{column_name}=",current)
  #     end
  #     current
  #   end
  #   class_module.send(:define_method, "#{column_name}_was") do
  #     current = instance_variable_get("@#{column_name}_was")
  #     return current if current.present?
  #     return nil unless (id = current_state_was["#{column_name}_id"]).present?
  #     current = klass.find(id)
  #     instance_variable_set("@#{column_name}_was",current)
  #     current
  #   end
  #   class_module.send(:define_method,"#{column_name}_id_type")    {:number}
  #   class_module.send(:define_method,"#{column_name}_id_view_type")  {:active_record}
  #   class_module.send(:define_method,"#{column_name}_options") {klass.all.map(&:to_s)}
  # end

end
