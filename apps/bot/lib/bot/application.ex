defmodule Bot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Supervisor

  def start(_type, _args) do
    telegram_token = ExGram.Config.get(:ex_gram, :telegram_token)
    discord_token = ExGram.Config.get(:ex_gram, :discord_token)
    {:ok, file} = File.read("apps/bot/test.html")
    {:ok, doc} = Floki.parse_document(file)
    input = Floki.find(doc, ".text") |> Enum.map(fn x -> Floki.text(x) end)

    children = [
      ExGram,
      {Bot.Telegram, [method: :polling, token: telegram_token]},
      {Bot.Markov.Model, input},
      %{
        id: Bot.Discord,
        start: {Alchemy.Client, :start, [discord_token]}
      }
    ]

    opts = [strategy: :one_for_one, name: Bot.Supervisor]
    res = Supervisor.start_link(children, opts)

    use Bot.Discord

    res
  end
end
