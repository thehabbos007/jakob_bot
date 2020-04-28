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

config :ex_gram, discord_token: {:system, "DISCORD_TOKEN"}
config :ex_gram, telegram_token: {:system, "TELEGRAM_TOKEN"}


config :alchemy,
  ffmpeg_path: "/usr/bin/ffmpeg",
  youtube_dl_path: "/usr/local/bin/youtube-dl"
