defmodule Persist.MarkovMessage do
  use Ecto.Schema

  import Ecto.Query, warn: false
  alias Persist.Repo
  alias Persist.MarkovMessage

  schema "markov_messages" do
    field :text, :string
    timestamps()
  end

  def changeset(message, params \\ %{}) do
    message
    |> Ecto.Changeset.cast(params, [:text])
    |> Ecto.Changeset.validate_required([:text])
  end

  def insert(text) do
    change = changeset(%MarkovMessage{}, %{text: text})
    case Repo.insert(change) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  def all() do
    Repo.all(from p in MarkovMessage, select: p.text)
  end
end
