defmodule Bot.Discord do
  use Alchemy.Cogs
  alias Alchemy.Voice

  Cogs.def ping do
    Cogs.say "pong!"
  end

  Cogs.def complete(text) do
    {response, _} = Bot.Markov.Generator.complete_sentence(text)
    {response, _} = if response == String.trim(text), do: Bot.Markov.Generator.create_sentence(), else: {response, :ok}
    Cogs.say response
  end

  Cogs.def play(url) do
    {:ok, id} = Cogs.guild_id()
    # joins the default channel for this guild
    # this will check if a connection already exists for you
    Voice.join(id, id)
    Voice.play_url(id, url)
    Cogs.say "Now playing #{url}"
  end
end
