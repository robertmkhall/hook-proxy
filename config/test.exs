use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hook_proxy, HookProxy.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bypass, enable_debug_log: true

config :hook_proxy, :slack,
  webhook_slug: "/test-slug"

# Configure your database
config :hook_proxy, HookProxy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hook_proxy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
