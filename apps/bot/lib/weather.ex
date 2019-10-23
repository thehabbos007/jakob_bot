defmodule Bot.Weather do
  @moduledoc """
  OpenWeather wrapper
  """
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.openweathermap.org/data/2.5"
  plug Tesla.Middleware.JSON

  def get() do
    token = ExGram.Config.get(:bot, :weather_key)
    {:ok, %Tesla.Env{:body => body}} = get(
      "/weather",
      query: [q: "lyngby,dk", units: "metric", APPID: token]
    )

    parse(body)
  end

  defp parse(%{"main" => %{"temp" => temp}}), do: temp
  defp parse(_), do: nil

end
