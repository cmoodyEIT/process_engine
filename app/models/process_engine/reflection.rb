module ProcessEngine::Reflection
  def has_many(join_name,scope=nil,options={},&extension)
    scope,options = check_scope_options(scope,options)
    override = options.delete(:override)
    return super(join_name,scope,options,&extension) if override
    return super if join_name.to_s.include?('joined_instances') || join_name.to_s.include?('instances_joined')

    new_reflection = HasMany.new(self,join_name,options)

    name, through_scope, options = new_reflection.through
    super name, ->{where(through_scope)}, options
    name, scope, options = new_reflection.join
    super name, ->{where(scope)}, options
  end
  def has_and_belongs_to_many(join_name,scope=nil,options={},&extension)
    scope,options = check_scope_options(scope,options)
    has_many(join_name,scope,options.merge(belongs_to_many: true),&extension)
  end

  def has_one(join_name,scope=nil,options={},&extension)
    scope,options = check_scope_options(scope,options)
    return super if join_name.to_s.include?('joined_instance')
    override = options.delete(:override)
    return super(join_name,scope,options,&extension) if override

    new_reflection = HasOne.new(self,join_name,options)

    name, through_scope, options = new_reflection.through
    super name, ->{where(through_scope)}, options
    name, scope, options = new_reflection.join
    super name, ->{where(scope)}, options

    new_reflection.define_getters_setters
  end

  def belongs_to(join_name,scope=nil,options={},&extension)
    scope,options = check_scope_options(scope,options)
    has_one(join_name,scope,options.merge({belongs_to: true}),&extension)
    return
  end
  private
    def check_scope_options(scope,options)
      scope.is_a?(Hash) ? [nil,scope] : [scope,options]
    end

end
