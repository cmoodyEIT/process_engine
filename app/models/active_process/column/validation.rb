module ActiveProcess::Column::Validation

  def unmet_dependencies?() [options[:dependent]].flatten.map(&:present?).inject(&:&) end
  def compile_errors(record)
    if record.send(column_name).present?
      [options[:dependent]].flatten.each do |atom|
        record.errors.add(name, :unmet_dependencies, message: "must have its dependencies met")
      end
    end
    # puts unmet_dependencies?
    # # record.errors.add(name, :unmet_dependencies, message: "must have its dependencies met") if unmet_dependencies?
    # puts record
    # puts record.errors.details
  end
  def valid?
    !unmet_dependencies?
  end
end
