Pay::Square::Engine.routes.draw do
  post "webhooks/square", to: "pay/webhooks/square#create" if Pay::Square.enabled?
end
