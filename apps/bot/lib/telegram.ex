defmodule Bot.Telegram do
  @bot :jakob_bot
  use ExGram.Bot, name: @bot

  @exclaim ~r/^jakob!/iu
  regex(@exclaim, :ai_msg)

  @normal ~r/^jakob,/iu
  regex(@normal, :normal)


  require Logger

  def handle({:text, msg, meta}, ctx) do
    msg_id = extract_response_id(meta)

    if Enum.random(0..100) >= 97 do
      random_topic = msg
      |> String.split
      |> Enum.random

      response = markov_empty_wrapper(random_topic)
      answer(ctx, response, reply_to_message_id: msg_id)
    else
      nil
    end
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
    msg_id = extract_response_id(msg)
    text = msg.text |> String.replace(~r/^jakob!/iu, "")

    response = markov_empty_wrapper(text)
    answer(ctx, response, reply_to_message_id: msg_id)
  end

  def markov_empty_wrapper(text) do
    {response, _} = Bot.Markov.Generator.complete_sentence(text)
    {response, _} = if response == String.trim(text), do: Bot.Markov.Generator.create_sentence(), else: {response, :ok}
    response
  end

  def handle(msg, _), do: nil

end
