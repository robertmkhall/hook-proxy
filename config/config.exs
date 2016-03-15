# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :hook_proxy, HookProxy.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "wytxpJpYM5ZS09j3uarQTuNeF4rkQSRu4LhpIOJMlU+JnOc1xLu+qPIdwk9FkFST",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: HookProxy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hook_proxy, :slack,
  base_url: "https://hooks.slack.com",
  webhook_slug: System.get_env("SLACK_WEBHOOK_SLUG"),
  custom_message: System.get_env("SLACK_CUSTOM_MESSAGE")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
