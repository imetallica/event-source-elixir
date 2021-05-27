defmodule Es.Projections.OrderProjection do
  @moduledoc """
  Projects orders into an CSV file.
  """
  alias Es.Events.OrderCreated

  @behaviour :gen_event

  def init(_args) do
    {:ok, %{}}
  end

  def handle_event(event, state) do
  end
end
