defmodule Bot.Ai.Ai do
  @moduledoc """
  Wit.ai wrapper
  """
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.wit.ai"
  plug Tesla.Middleware.Headers,
    [{
      "Authorization",
      "Bearer " <> ExGram.Config.get(:bot, :witai_key)
    }]
  plug Tesla.Middleware.JSON

  def analyse(data) do
    {:ok, %Tesla.Env{:body => body}} = get(
      "/message",
      query: [q: data]
    )
    {:ok, body}
  end

  @spec parse({:ok, nil | keyword | map}) ::
          nil
          | {:reminder_remove}
          | {:schooltime_get}
          | {:weather_get}
          | {:reminder_create, any}
          | {:reminder_remove, number}
          | {:schooltime_get, any}
  def parse({:ok, data}), do: parse_raw(data["entities"])

  defp parse_raw(%{"intent" => [%{"value" => "schooltime_get", "confidence" => conf} | _ ]} = raw)
  when conf > 0.8 do
    with {:ok, date} <- get_date(raw) do
      {:schooltime_get, date}
    else
      _ -> {:schooltime_get}
    end
  end

  defp parse_raw(%{"intent" => [%{"value" => "reminder_remove", "confidence" => conf} | _ ]} = raw)
  when conf > 0.8 do
    with {:ok, number} <- get_reminder_num(raw) do
      {:reminder_remove, number}
    else
      _ -> {:reminder_remove}
    end
  end

  defp parse_raw(%{"intent" => [%{"value" => "weather_get", "confidence" => conf} | _ ]})
  when conf > 0.8, do: {:weather_get}
  defp parse_raw(%{"reminder" => [%{"value" => text, "confidence" => conf} | _ ]})
  when conf > 0.8, do: {:reminder_create, text}
  defp parse_raw(_), do: nil


  defp get_reminder_num(%{"number" => [%{"value" => num, "confidence" => conf} | _ ]})
  when conf > 0.8, do: {:ok, abs(num)}
  defp get_reminder_num(_), do: {:error, nil}

  defp get_date(%{"datetime" => [%{"value" => date, "confidence" => conf} | _ ]})
  when conf > 0.8, do: {:ok, date}
  defp get_date(_), do: {:error, nil}

end
