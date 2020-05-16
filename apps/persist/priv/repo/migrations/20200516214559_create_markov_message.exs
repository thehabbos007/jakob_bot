defmodule Persist.Repo.Migrations.CreateMarkovMessage do
  use Ecto.Migration

  def change do
    create table("markov_messages") do
      add :text, :text
      timestamps()
    end
  end

  def down do
    drop table("markov_messages")
  end
end
