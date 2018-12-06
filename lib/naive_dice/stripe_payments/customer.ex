defmodule NaiveDice.StripePayments.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :email, :string
    field :stripe_token, :string
    field :stripe_token_type, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:email, :stripe_token, :stripe_token_type])
    |> validate_required([:email, :stripe_token, :stripe_token_type])
  end
end
