module ActiveProcess::Schema
  ################################
  #  Allowed Types are: :string, :text, :float, :integer :date, :date_time, :boolean
  #  Any inheritance of ActiveRecord::Base
  #  If type is left blank, defaults to :string
  def has_columns(columns={})
    class_module = Module.new
    @inspector_fields = column_names - ["current_state"]
    self.process_columns = columns.map{|column_name,options| ActiveProcess::Column.new(column_name,options,class_module)}
      # create_roles(options[:manageable])
      # add_to_whitelist(column_name)
    const_set('Base',class_module)
    include "#{name}::Base".constantize
  end
  #   puts base
  #   base.send :cattr_accessor, :process_columns
  #   base.send(:define_method,  :process_columns) {self.class.process_columns}
  # end

  # private
  #   def create_roles(*all_roles)
  #     new_roles = (all_roles.flatten.compact.map(&:to_sym).uniq - roles.pluck(:name).map(&:to_sym)).map{|r| {name: r}}
  #     roles.create(new_roles) if new_roles.present?
  #   end

end
