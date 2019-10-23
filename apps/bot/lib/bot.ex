defmodule Bot.Poller do
  @bot :jakob_bot
  use ExGram.Bot, name: @bot

  regex(~r/^jakob!/iu, :ai_msg)
  regex(~r/^jakob/iu, :normal)


  require Logger

  def handle({:text, msg, _meta}, cnt) do
    #cnt |> answer(msg)
    nil
  end

  def handle({:regex, :normal, msg}, cnt) do
    #cnt |> answer("Testerino back")
    IO.puts "normal"
    IO.inspect msg
    nil
  end

  def handle({:regex, :ai_msg, msg}, cnt) do
    #cnt |> answer("Testerino back")
    text = msg.text
    response = String.slice(text, 6..-1)
    |> Bot.Ai.analyse
    |> Bot.Ai.parse
    |> Bot.Decider.decide

    answer(cnt, response, reply_to_message_id: msg.message_id)
  end

  def handle(msg, _), do: nil

end
