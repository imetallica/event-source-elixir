defmodule Es.Aggregates.Order.State do
  @moduledoc """
  The state schema underlying.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:id, :id)
    field(:external_id, :string)
    field(:retailer_id, :string)
    field(:created_at, :utc_datetime)
    field(:expected_delivery_date, :utc_datetime)
    field(:effective_delivery_date, :utc_datetime)
    field(:status, Ecto.Enum, values: ~w(new open )a)

    embeds_many :products, Product do
      field(:quantity, :integer)
      field(:external_id, :string)
      field(:backordered?, :boolean)
    end
  end

  @state_params ~w(id external_id retailer_id status created_at expected_delivery_date effective_delivery_date)a
  @state_required ~w(id external_id retailer_id status created_at expected_delivery_date)a
  def validate_schema(state \\ %__MODULE__{}, params) when is_map(params) do
    state
    |> cast(params, @state_params)
    |> cast_embed(:products, with: &product_changeset/2)
    |> validate_required(@state_required)
    |> apply_action(:update)
  end

  @products_required ~w(quantity external_id backordered?)a
  defp product_changeset(state, params) when is_map(params) do
    state
    |> cast(params, @products_required)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_required(@products_required)
  end
end
