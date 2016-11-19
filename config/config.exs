# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :webhook_proxy, WebhookProxy.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jtgta3HEuPmLxQ8lCvigEC1l6rhOfMp6txpLOyEQpSnQqkgDj+J0nJJYjm09Ue3w",
  render_errors: [view: WebhookProxy.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebhookProxy.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :webhook_proxy, proxy_url: System.get_env("WEBHOOK_PROXY_URL") || (IO.puts("WEBHOOK_PROXY_URL environmental variable required") && System.halt(1))

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :basic_auth, webhook: [
  username: {:system, "WEBHOOK_USERNAME"},
  password: {:system, "WEBHOOK_PASSWORD"},
  realm:    "webhook",
]

config :basic_auth, webhook_test: [
  username: "real_username",
  password: "real_password",
  realm:    "webhook_test"
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
