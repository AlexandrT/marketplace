module Marketplace
  class Engine < ::Rails::Engine
    isolate_namespace Marketplace
    config.autoload_paths << Marketplace::Engine.root.join("app/models/marketplace")
  end
end
