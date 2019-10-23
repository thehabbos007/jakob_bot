defmodule Persist.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table("todos") do
      add :user_id, :integer
      add :item, :string
      add :completed, :boolean, default: false

      timestamps()
    end
  end

  def down do
    drop table("todos")
  end
end
