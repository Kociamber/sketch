defmodule Sketch.Repo do
  use Ecto.Repo,
    otp_app: :sketch,
    adapter: Ecto.Adapters.Postgres
end
