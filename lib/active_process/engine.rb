module ActiveProcess
  class Engine < ::Rails::Engine
    isolate_namespace ActiveProcess
  end
end
