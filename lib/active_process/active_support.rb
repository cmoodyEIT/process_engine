module ActiveSupport
  module Dependencies
    alias :_load_missing_constant :load_missing_constant
    def load_missing_constant(from_mod, const_name)
      begin
        _load_missing_constant(from_mod, const_name)
      rescue NameError => e
        qualified_name = qualified_name_for from_mod, const_name
        if !!(qualified_name =~ /Controller$/)
          return Object.const_set(qualified_name, Class.new(ActiveProcess::ApplicationController))
        end
        raise e
      end
    end
  end
end
