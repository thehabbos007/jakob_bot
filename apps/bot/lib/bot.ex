defmodule Bot.Handler do
  @bot :jakob_bot
  use ExGram.Bot, name: @bot

  @exclaim ~r/^jakob!/iu
  regex(@exclaim, :ai_msg)

  @normal ~r/^jakob/iu
  regex(@normal, :normal)


  require Logger

  def handle({:text, msg, _meta}, ctx) do
    #answer(ctx, msg)
    nil
  end

  def handle({:regex, :normal, msg}, ctx) do
    msg_id = extract_response_id(msg)
    response = case :rand.uniform(4) do
      1 -> "Ja"
      2 -> "Nej"
      3 -> "Måske"
      4 -> "Næ."
      _ -> "wtf"
    end
    answer(ctx, response, reply_to_message_id: msg_id)
  end

  def handle({:regex, :ai_msg, msg}, ctx) do
    #ctx |> answer("Testerino back")
    text = msg.text
    response = String.slice(text, 6..-1)
    |> Bot.Ai.analyse
    |> Bot.Ai.parse
    |> Bot.Decider.decide

    answer(ctx, response, reply_to_message_id: msg.message_id)
  end

  def handle(msg, _), do: nil

end
