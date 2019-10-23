defmodule Persist.Repo do
  use Ecto.Repo,
    otp_app: :persist,
    adapter: Ecto.Adapters.Postgres
end
