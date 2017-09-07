class ActiveProcess::Column
  include Validation
  def initialize(name,options,parent)
    @name         = name
    @type         = options[:type] || :string
    @options      = options || {}
    @klass        = type.to_s.classify.safe_constantize || String
    @base_class   = parent
    define_methods
    base_class.send(:define_method,"#{name}_options") {options[:options]} if options[:options].present?
    base_class.send(:define_method,"#{name}_type")    {options[:type] || :string}
  end
  attr_reader :name, :type, :klass, :options, :base_class
  def singular?() type.to_s == type.to_s.singularize end
  def active_record?() klass < ActiveRecord::Base end
  def column_name()
    @column_name = name.to_s
    if active_record?
      @column_name = name.to_s.singularize + (singular? ? '_id' : '_ids')
    end
    @column_name
  end
  def value(current_state,update=false,value=nil)
    if update
      current_state[column_name] = value
    else
      res = [current_state[column_name]].flatten.map{|val| type_caster.cast val}
      singular? ? res[0] : res
    end
  end
  def active_record(current_state,update=false,arg=nil)
    if update
      value(current_state,true,(singular? ? arg.id : arg.map(&:id)))
      @active_record = arg
    else
      @active_record ||= klass.find(value(current_state))
    end
  end
  def active_record_was(current_state_was)
    @active_record_was ||= klass.find(value(current_state_was))
  end

  private
    def type_caster
      caster_type = active_record? ? 'Integer' : type.to_s.classify
      "ActiveRecord::Type::#{caster_type}".safe_constantize.new
    end
    def define_methods
      column = self
      base_class.send(:define_method,"#{column_name}") do
        column.value(current_state)
      end
      base_class.send(:define_method,"#{column_name}_was") do
        column.value(current_state_was)
      end
      base_class.send(:define_method,"#{column_name}=") do |arg|
        column.value(current_state,true,arg)
      end
      define_active_records if active_record?
    end
    def define_active_records
      column = self
      base_class.send(:define_method,"#{name}") do
        column.active_record(current_state)
      end
      base_class.send(:define_method,"#{name}_was") do
        column.active_record_was(current_state_was)
      end
      base_class.send(:define_method,"#{name}=") do |arg|
        column.active_record(current_state,true,arg)
      end
    end
  #   class_module.send(:define_method,"#{column_name}_id_type")    {:number}
  #   class_module.send(:define_method,"#{column_name}_id_view_type")  {:active_record}
  #   class_module.send(:define_method,"#{column_name}_options") {klass.all.map(&:to_s)}
  # end

end
