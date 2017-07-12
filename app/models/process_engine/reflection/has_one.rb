class ProcessEngine::Reflection::HasOne
  def initialize(primary,join_name,options)
    @primary   = primary
    @join_name = join_name
    @options   = options
    set_options
  end

  attr_reader :primary,:join_name, :options
  def through() [first_join_name, first_scope, first_join_details] end
  def join()    [join_name, conditions, options] end
  def conditions() klass < ProcessEngine::Instance ? {type: class_name} : {} end

  # Build methods not created on has_one through
  def define_getters_setters
    method,new_class,inverse = [join_name,klass,inverse_of.to_s]
    primary.send(:define_method, "build_#{method}") do |attributes={}|
      record = new_class.new(attributes)
      if record.respond_to?(inverse.pluralize)
        record.send(inverse.pluralize).push self
      elsif record.respond_to?(inverse.singularize)
        record.send("#{inverse.singularize}=",self)
      end
      record
    end
    primary.send(:define_method, "create_#{method}") do |attributes={}|
      record = send("build_#{method}",attributes)
      record.save
      record
    end
    primary.send(:define_method, "create_#{method}!") do |attributes={}|
      record = send("build_#{method}",attributes)
      record.save!
      record
    end
    which_relation = first? ? :second_active_record_id : :first_active_record_id
    primary.send(:define_method, "#{method}_id") do
      send("#{method}_joined_instance").send(which_relation)
    end
    primary.send(:define_method, "#{method}_id=") do |id|
      send("#{method}=",new_class.find(id))
    end
  end

  private
    def belongs_to?()  !!@belongs_to end
    def inverse_of
      res = options[:inverse_of] || primary.name.underscore.split('/').last()
      belongs_to? ? res.pluralize : res
    end
    def class_name() (options[:class_name] || join_name).to_s.classify end
    def klass()      class_name.constantize end
    def first?()     [primary.name,class_name].sort.index(primary.name) == 0 end

    def first_join_name() "#{join_name}_joined_instance".to_sym end
    def first_join_details()
      {class_name: 'ProcessEngine::JoinedInstance', as: (first? ? :first_active_record : :second_active_record)}
    end
    # set First Join scope so that record is created with proper details
    def first_scope
      conditions = {}
      conditions[:belongs_to_as] = belongs_to? ? join_name  : inverse_of
      conditions[:has_as]        = belongs_to? ? inverse_of : join_name.to_s.pluralize

      conditions[:first_active_record_class]  = first? ? @primary.name : class_name
      conditions[:second_active_record_class] = first? ? class_name    : @primary.name
      conditions
    end

    def set_options
      @belongs_to = @options.delete(:belongs_to)
      @options[:through] = first_join_name
      @options[:source_type] = klass.base_class.name
      @options[:class_name]  = class_name
      @options[:source]      = first? ? :second_active_record : :first_active_record
    end

    def define_build
    end
end
