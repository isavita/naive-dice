defmodule NaiveDice.StripePayments.ChargeInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.StripePayments.Checkout

  schema "charge_infos" do
    field :charge, :map
    field :outcome, :map
    field :source, :map
    belongs_to :checkout, Checkout

    timestamps()
  end

  @doc false
  def changeset(charge_info, attrs) do
    charge_info
    |> cast(attrs, [:checkout_id, :charge, :outcome, :source])
    |> validate_required([:checkout_id, :charge, :outcome, :source])
  end
end
