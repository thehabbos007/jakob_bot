import Config

config :persist, Persist.Repo,
  database: "persist_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"


config :persist, ecto_repos: [Persist.Repo]


config :tesla, adapter: Tesla.Adapter.Mint
config :tesla, Tesla.Middleware.Logger, debug: false

config :bot, witai_key: {:system, "WITAI_TOKEN"}
config :bot, weather_key: {:system, "WEATHER_TOKEN"}

config :ex_gram, token: {:system, "TELEGRAM_TOKEN"}
