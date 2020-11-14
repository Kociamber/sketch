# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sketch,
  default_row_size: 32,
  default_column_size: 12,
  storage_name: :sketch_storage
  
# Configures the endpoint
config :sketch, SketchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z9kDhEThPdguZah+GP/d/7WKOb/D7rAqbxr2MxxVz4f2mKgPA7vWBE0JWBIml0lG",
  render_errors: [view: SketchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sketch.PubSub,
  live_view: [signing_salt: "uNS1HVzZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
