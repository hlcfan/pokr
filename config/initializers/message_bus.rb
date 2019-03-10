# we want MesageBus in the absolute front
# this is important cause the vast majority of web requests go to it
# this allows us to avoid full middleware crawls each time
# Pending https://github.com/rails/rails/pull/27936
# From https://github.com/discourse/discourse/blob/acd1693dac1bff6ff50250d942134bc48a27ff14/config/initializers/200-message_bus_request_tracker.rb
session_operations = Rails::Configuration::MiddlewareStackProxy.new([
  [:delete, MessageBus::Rack::Middleware],
  [:unshift, MessageBus::Rack::Middleware],
])

Rails.configuration.middleware = Rails.configuration.middleware + session_operations

MessageBus.configure(backend: :redis, url: "redis://localhost:6379/1")