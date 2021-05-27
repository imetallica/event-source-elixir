defmodule Es.Commands.CreateOrder do
  @moduledoc """
  Schema module that validates the create order .
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
          purchase_order_number: String.t(),
          retailer_number: String.t(),
          order_date: DateTime.t(),
          expected_delivery_date: DateTime.t(),
          products: [
            %__MODULE__.Product{
              product_number: String.t(),
              quantity: non_neg_integer(),
              can_be_backordered: boolean()
            }
          ]
        }

  embedded_schema do
    field(:purchase_order_number, :string)
    field(:retailer_number, :string)
    field(:order_date, :utc_datetime)
    field(:expected_delivery_date, :utc_datetime)

    embeds_many :products, Product do
      field(:product_number, :string)
      field(:quantity, :integer)
      field(:can_be_backordered, :boolean)
    end
  end

  @required_params ~w(purchase_order_number retailer_number order_date expected_delivery_date)a
  @product_required_params ~w(product_number quantity can_be_backordered)a

  @doc """
  Validates that the data from the command has valid format.
  """
  @spec validate_schema(params :: map) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def validate_schema(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> cast_embed(:products, required: true, with: &product_changeset/2)
    |> validate_required(@required_params)
    |> validate_delivery()
    |> apply_action(:insert)
  end

  defp validate_delivery(changeset) do
    if changeset.valid? do
      order_date = get_field(changeset, :order_date)
      expected_delivery_date = get_field(changeset, :expected_delivery_date)

      case Date.compare(expected_delivery_date, order_date) do
        :gt ->
          changeset

        _ ->
          add_error(changeset, :expected_delivery_date, "is invalid")
      end
    else
      changeset
    end
  end

  defp product_changeset(product, params) do
    product
    |> cast(params, @product_required_params)
    |> validate_required(@product_required_params)
    |> validate_number(:quantity, greater_than: 0)
  end
end
