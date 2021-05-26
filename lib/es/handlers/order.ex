defmodule ES.Handlers.Order do
  @moduledoc """
  Handles the orders from external systems.
  """
  use DynamicSupervisor

  @spec create_order(params :: map()) :: :ok | {:error, term}
  def create_order(params) do
    raise "IMPLEMENT"
  end

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_args) do
    do_load_orders()

    DynamicSupervisor.init(strategy: :one_for_one)
  end


  defp do_load_orders do
    []
  end
end
