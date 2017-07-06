# class ProcessEngine::TypeCaster
#   def initialize(object)
#     @object = object
#   end
#
#   def to(type)
#     case type.to_sym
#     when :string
#       @object.to_s
#     when :text
#       @object.to_s
#     when :number
#       self.include?('.') ? @object.to_f : @object.to_i
#     when :date
#       Date.parse(@object, false)
#     when :boolean
#       @object.downcase == 'true' || @object == '1' || @object.downcase == 't'
#     else
#       @object
#     end
#   end
# end
