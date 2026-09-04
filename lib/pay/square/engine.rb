require "rails/engine"

module Pay
  module Square
    class Engine < ::Rails::Engine
      engine_name "pay_square"

      initializer "pay_square.processors" do |app|
        if Pay.automount_routes
          app.routes.append do
            mount Pay::Square::Engine, at: Pay.routes_path
          end
        end

        ActiveSupport.on_load(:active_record) do
          include Pay::Attributes
        end
      end

      # Subscribe webhooks before app initializers, matching Pay's own ordering.
      config.before_initialize do
        Pay::Square.configure_webhooks if Pay::Square.enabled?
      end

      config.to_prepare do
        Pay::Square.setup if Pay::Square.enabled?
      end
    end
  end
end
