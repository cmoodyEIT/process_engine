class ProcessEngine::Reflection::HasMany
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
  private
    def inverse()    @options.delete(:inverse_of) || primary.name.underscore.split('/').last() end
    def class_name() (options[:class_name] || join_name).to_s.classify end
    def klass()      class_name.constantize end
    def first?()     [primary.name,class_name].sort.index(primary.name) == 0 end

    def first_join_name() "#{join_name}_joined_instances".to_sym end
    def first_join_details()
      {class_name: 'ProcessEngine::JoinedInstance', as: (first? ? :first_active_record : :second_active_record)}
    end
    # set First Join scope so that record is created with proper details
    def first_scope
      conditions = options.delete(:belongs_to_many) ? {} : {has_as: join_name, belongs_to_as: inverse}
      conditions[:first_active_record_class]  = first? ? @primary.name : class_name
      conditions[:second_active_record_class] = first? ? class_name    : @primary.name
      conditions
    end

    def set_options
      @options[:source] = first? ? :second_active_record : :first_active_record
      @options.merge!({class_name: class_name, source_type: klass.base_class.to_s,through: first_join_name})
      # sets 'imaginary' reference to association so that the reference exists on create (mimicks standard has_many behavior)
      @options[:before_add] = ->(existing,created) do
        ref = created.class.reflect_on_all_associations.select{|a| a.name.to_sym == inverse.to_sym}.first
        return unless ref.present?
        association = ActiveRecord::Associations::HasOneAssociation.new(created.class,ref)
        association.target = existing
        created.instance_variable_set("@association_cache", {}) if created.instance_variable_get("@association_cache").nil?
        created.instance_variable_get("@association_cache")[inverse.to_sym] = association
      end
    end

end
