module Tybo
  class Engine < ::Rails::Engine
    isolate_namespace Tybo
    initializer "tybo.assets" do |app|
      app.config.assets.precompile += %w[tybo_manifest]
    end
  end
end

