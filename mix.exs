defmodule WebhookProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :webhook_proxy,
     #version: "0.1.0",
     version: (File.read!("VERSION") |> String.rstrip),
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    # Original:
    # [mod: {WebhookProxy, []},
    #  applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext]]
    # However, we do not need phoenix_pubsub or phoenix_html, removing.
    [mod: {WebhookProxy, []},
     applications: [:phoenix, :cowboy, :basic_auth, :httpoison, :logger, :gettext]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     # Do not need these for our proxy
     # {:phoenix_pubsub, "~> 1.0"},
     # {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:basic_auth, "~> 2.0.0"}, # Simple HTTP basic auth plug
     {:httpoison, "~> 0.10.0"}, # HTTP client backed by hackney (streaming binary) and Poison (fast JSON)
     {:exrm, "~> 1.0.0"} # Elixir Release Manager. When Distillery comes out of beta, switch to that
    ]
  end
end
