use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sketch,
  storage_name: :sketch_storage_test

config :sketch, SketchWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
