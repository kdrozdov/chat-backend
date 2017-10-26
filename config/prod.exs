use Mix.Config

config :logger, level: :info

config :api, ApiWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: System.get_env("APP_HOST"), port: 443],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  check_origin: [System.get_env("CORS_ORIGIN")]

config :api, Api.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :guardian, Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :cors_plug, CORSPlug,
  origin: [System.get_env("CORS_ORIGIN")]
