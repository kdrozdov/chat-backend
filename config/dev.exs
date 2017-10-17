use Mix.Config

import_config "dev.secret.exs"

config :api, ApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :api, Api.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "api_dev",
  hostname: "localhost",
  pool_size: 10
