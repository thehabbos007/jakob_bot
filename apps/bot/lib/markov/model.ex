defmodule Bot.Markov.Model do
  use Agent

  def start_link(datasource) when is_list(datasource)  do
    :random.seed(:os.timestamp)
    res = Agent.start_link(fn -> Map.new end, name: __MODULE__)
    for text <- datasource, do: populate_model(text)
    res
  end

  def populate_model(datasource) when is_list(datasource) do
    for text <- datasource, do: populate_model(text)
    {:ok}
  end

  def populate_model(text) when is_binary(text) do
    tokens = tokenize(text)
    tokens |> Enum.with_index |> Enum.each(fn ({token, index}) ->
      markov_state = get_markov_state(tokens, index)
      add_token(markov_state, token)
    end)
  end

  def tokenize(str) do
    str
    |> String.split
    |> Enum.reject(fn s -> String.length(s) == 0 end)
  end

  defp add_token(markov_state, token) do
    Agent.update(__MODULE__, fn model ->
      current_state = model[markov_state] || []
      new_state = [token | current_state]
      model |> Map.put(markov_state, new_state)
    end)
  end

  def get_state_tokens(markov_state) do
    Agent.get(__MODULE__, fn model -> model[markov_state] || [] end)
  end

  def remove_state_token(markov_state) do
    Agent.update(__MODULE__, &Map.delete(&1, markov_state))
  end

  def reset_model, do: Agent.update(__MODULE__, &Map.new/0)

  def get_markov_state(tokens) do
    get_markov_state(tokens, length(tokens))
  end

  def get_markov_state(_tokens, index) when index == 0 do
    {nil, nil}
  end

  def get_markov_state([head | _tail], index) when index == 1 do
    {nil, head |> String.downcase}
  end

  def get_markov_state(tokens, index) when index > 1 and index <= length(tokens) do
    [value1, value2] = tokens
                       |> Enum.slice((index - 2)..(index - 1))
                       |> Enum.map(&String.downcase/1)
    {value1, value2}
  end

  def get_random_token(markov_state) do
    tokens = get_state_tokens(markov_state)
    if length(tokens) > 0 do
      token = Enum.random(tokens)
      token_count = Enum.count(tokens, fn t -> t == token end) * 1.0
      token_probability = token_count / length(tokens)
      {token, token_probability}
    else
      {'', 0.0}
    end
  end
end
