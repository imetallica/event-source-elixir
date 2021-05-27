defmodule Es.Events.OrderCreated do
  @moduledoc """
  Event generated from `Es.Commands.CreateOrder`.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:id, :id)
    field(:created_at, :date)
  end
end
