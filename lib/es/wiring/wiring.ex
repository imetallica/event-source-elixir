defmodule Es.Wiring do
  @moduledoc """
  This wires everything together.
  """
  use DynamicSupervisor

  def get_or_register_process(unique_id, mfa) do
    case Registry.lookup(LocalRegistry, unique_id) do
      [] ->
        DynamicSupervisor.start_child(__MODULE__, %{
          id: unique_id,
          start: mfa
        })

      [{pid, _}] ->
        {:ok, pid}
    end
  end

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
