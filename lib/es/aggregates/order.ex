defmodule Es.Aggregates.Order do
  @moduledoc """
  This module handles the lifecycle of an order.
  """
  alias Es.Aggregates.Order.State
  alias Es.Commands.CreateOrder
  alias Es.Events.OrderCreated
  alias Es.Wiring

  @behaviour :gen_statem

  def create(params) when is_map(params) do
    with {:ok, co = %CreateOrder{}} <- CreateOrder.validate_schema(params),
         uid = unique_identifier(co),
         {:ok, _pid} <- Wiring.get_or_register_process(uid, {__MODULE__, :start_link, [co]}) do
      :ok
    end
  end

  def start_link(state = %State{}) do
    :gen_statem.start_link(
      {:via, Registry, {LocalRegistry, state.id}},
      __MODULE__,
      state,
      []
    )
  end

  def callback_mode, do: :state_functions

  def init(co = %CreateOrder{}) do
    {:ok, %{}, %{}, {:next_event, :order_created, co}}
  end

  def order_created(:cast, co = %CreateOrder{}, data) do
    with {:ok, state = %State{}} <- from_create_order_to_state(co),
         {:ok, event = %OrderCreated{}} <- from_state_to_event(state),
         :ok <- persist_state(state),
         :ok <- :gen_event.notify(OrderProjectionManager, event) do
    end
  end

  defp unique_identifier(co = %CreateOrder{}),
    do: :erlang.phash2("#{co.retailer_number}-#{co.purchase_order_number}")

  defp from_create_order_to_state(co = %CreateOrder{})
  defp from_state_to_event(state = %State{})
  defp persist_state(state = %State{})
end
