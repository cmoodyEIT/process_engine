module ProcessEngine::Schema
  ################################
  #  Allowed Types are: :string, :text, :float, :integer :date, :time, :boolean
  #  Any inheritance of ActiveRecord::Base
  #  If type is left blank, defaults to :string
  def has_columns(columns={})
    class_module = Module.new
    @process_columns = columns.map{|column_name,options| ProcessEngine::Column.new(column_name,options,class_module)}
    @inspector_fields = column_names - ["current_state"]

      # create_roles(options[:manageable])
      # add_to_whitelist(column_name)
    const_set('Base',class_module)
    include "#{name}::Base".constantize
  end
  # private
  #   def create_roles(*all_roles)
  #     new_roles = (all_roles.flatten.compact.map(&:to_sym).uniq - roles.pluck(:name).map(&:to_sym)).map{|r| {name: r}}
  #     roles.create(new_roles) if new_roles.present?
  #   end

end
