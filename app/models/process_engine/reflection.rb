module ProcessEngine::Reflection
  def has_and_belongs_to_many(join_name,scope=nil,options={},&extension)
    if scope.is_a?(Hash)
      options = scope
      scope   = nil
    end
    has_many(join_name,scope,options.merge(belongs_to_many: true),&extension)
  end
  def has_many(join_name,scope=nil,options={},&extension)
    if scope.is_a?(Hash)
      options = scope
      scope   = nil
    end
    override = options.delete(:override)
    return super(join_name,scope,options,&extension) if override
    return super if join_name.to_s.include?('joined_instances') || join_name.to_s.include?('instances_joined')
    inverse    = options.delete(:inverse_of) || self.name.underscore.split('/').last()
    class_name = (options[:class_name] || join_name).to_s.classify
    klass      = class_name.constantize
    # Setup primary join for join through to function
    first_join_name = "#{join_name}_joined_instances".to_sym
    first_join_details={class_name: 'ProcessEngine::JoinedInstance'}
    if [self.name,class_name].sort.index(self.name) == 0
      first_join_details[:as]  = :first_active_record
      options[:source]         = :second_active_record
    else
      first_join_details[:as]  = :second_active_record
      options[:source]         = :first_active_record
    end

    # set First Join scope so that record is created with proper details
    first_scope = options.delete(:belongs_to_many) ? nil : ->{where({has_as: join_name, belongs_to_as: inverse})}
    has_many first_join_name, first_scope, first_join_details

    #Setup pertinent join with join through
    options.merge!({class_name: class_name, source_type: klass.base_class.to_s,through: first_join_name})
    # sets 'imaginary' reference to association so that the reference exists on create (mimicks standard has_many behavior)
    options[:before_add] = ->(existing,created) do
      ref = created.class.reflect_on_all_associations.select{|a| a.name.to_sym == inverse.to_sym}.first
      return unless ref.present?
      association = ActiveRecord::Associations::HasOneAssociation.new(created.class,ref)
      association.target = existing
      created.instance_variable_set("@association_cache", {}) if created.instance_variable_get("@association_cache").nil?
      created.instance_variable_get("@association_cache")[inverse.to_sym] = association
    end
    conditions = klass < ProcessEngine::Instance ? {type: class_name} : {}
    super join_name, ->{where(conditions)}, options

  end

  def has_one(join_name,scope=nil,options={},&extension)
    if scope.is_a?(Hash)
      options = scope
      scope   = nil
    end
    return super if join_name.to_s.include?('joined_instance')
    override = options.delete(:override)
    return super(join_name,scope,options,&extension) if override
    class_name = (options[:class_name] || join_name).to_s.classify
    klass = class_name.constantize
    conditions = {}
    if !!options.delete(:belongs_to)
      conditions[:belongs_to_as] = join_name
      inverse_of                 = options[:inverse_of] || self.name.tableize.split('/').last()
      join_details               = {has_as: inverse_of, belongs_to_as: join_name}
      conditions[:has_as]        = inverse_of
    else
      conditions[:has_as]        = join_name.to_s.pluralize
      inverse_of                 = options[:inverse_of] || self.name.underscore.split('/').last()
      join_details               = {has_as: join_name.to_s.pluralize, belongs_to_as: inverse_of}
      conditions[:belongs_to_as] = inverse_of
    end
    if [self.name,class_name].sort.index(self.name) == 0
      conditions[:second_active_record_class] = class_name
      has_one_conditions = {as: :first_active_record}
      final_conditions = {source: :second_active_record}
    else
      conditions[:first_active_record_class] = class_name
      has_one_conditions = {as: :second_active_record}
      final_conditions = {source: :first_active_record}
    end
    has_one_conditions.merge!({class_name: 'ProcessEngine::JoinedInstance'})
    final_conditions.merge!({through: "#{join_name}_joined_instance", source_type: klass.base_class.name,class_name: class_name})
    super "#{join_name}_joined_instance".to_sym, ->{where(conditions)}, has_one_conditions
    has_one join_name, final_conditions.merge(override: true)
    # Build methods not created on has_one through
    define_method "build_#{join_name}" do |attributes={}|
      record = klass.new(attributes)
      if record.respond_to?(inverse_of.pluralize)
        record.send(inverse_of.pluralize).push self
      else
        record.send("#{inverse_of.singularize}=",self)
      end
      record
    end
    define_method "create_#{join_name}" do |attributes={}|
      record = send("build_#{join_name}",attributes)
      record.save
      record
    end
    define_method "create_#{join_name}!" do |attributes={}|
      record = send("build_#{join_name}",attributes)
      record.save!
      record
    end
    define_method "#{join_name}_id" do |overflow = 0|
      return if overflow > 1
      id = instance_variable_get("@#{join_name}_id")
      id ||= send(join_name).try(:id) if send(join_name,false,overflow + 1).present?
      id
    end
    define_method "#{join_name}_id=" do |id|
      instance_variable_set("@#{join_name}_id",id)
      send("#{join_name}=",klass.find(id))
    end
    define_method join_name do |reload = false,overflow = 0|
      return if overflow > 1
      record = super(reload)
      record ||= klass.find(send("#{join_name}_id")) if send("#{join_name}_id",overflow + 1).present?
      record
    end
  end
  def belongs_to(join_name,scope=nil,options={},&extension)
    if scope.is_a?(Hash)
      options = scope
      scope   = nil
    end
    options = HashWithIndifferentAccess.new(options)
    klass = (options[:class_name] || join_name).to_s.classify.constantize
    @belongs_to ||= []
    @belongs_to << join_name
    # @role_resource ||= join_name
    # @role_resource   = join_name if options.delete(:role_resource)
    # @role_class    ||= klass
    # @role_class      = klass if options.delete(:role_resource)
    has_one(join_name,scope,options.merge({belongs_to: true}),&extension)
    # add_to_whitelist("#{join_name}_id")
    # add_to_json_methods("#{join_name}_id")
    # alias_attribute :parent, @role_resource
    # alias_method    :parent_id, "#{@role_resource}_id"
    # alias_method    :parent_id=, "#{@role_resource}_id="
  end
end
