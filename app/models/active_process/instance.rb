module ActiveProcess
  class Instance < ApplicationRecord
    extend ActiveProcess::Schema
    extend ActiveProcess::Reflection
    validate :validate_instance_columns

    def self.process_columns=(columns = []) @process_columns = columns end
    def self.process_columns() @process_columns || [] end
    def process_columns() self.class.process_columns end

    # TODO: place holder for roles
    def self.roles() [] end
    private
      def validate_instance_columns
        process_columns.each{|pc| pc.compile_errors(self) unless pc.valid?}
        puts errors[:base]
      end
  end
end
