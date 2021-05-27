defmodule Es.Projections.Supervisor do
  @moduledoc """

  """
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_attrs) do
    children = [
      %{
        id: OrderProjectionManager,
        start: {:gen_event, :start_link, [{:local, OrderProjectionManager}]}
      }
    ]

    {:ok, pid} = Supervisor.init(children, strategy: :one_for_one)

    # :gen_event.add_sup_handler(OrderManager, Order, [])

    {:ok, pid}
  end
end
