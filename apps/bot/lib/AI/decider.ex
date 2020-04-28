defmodule Bot.Ai.Decider do

  @spec decide(
          {:reminder_remove}
          | {:schooltime_get}
          | {:weather_get}
          | {:reminder_create, any}
          | {:reminder_remove, any}
          | {:schooltime_get, any}
        ) :: nil | <<_::184>> | number
  def decide(msg) do
    decide_action(msg)
  end

  defp decide_action({:weather_get}) do
    case Bot.Weather.get do
      x when is_number(x) -> "It's #{x} degrees or sumtin."
      _ -> "Pls man i don't know :("
    end
  end
  defp decide_action({:schooltime_get, time_string}), do: "nah"
  defp decide_action({:schooltime_get}), do: "nah"
  defp decide_action({:reminder_create, reminder_text}), do: "nah"
  defp decide_action({:reminder_remove, number}), do: "nah"
  defp decide_action({:reminder_remove}), do: "nah"

end
