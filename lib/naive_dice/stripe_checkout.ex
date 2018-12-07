defmodule NaiveDice.StripeCheckout do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stripe_checkouts" do
    field :email, :string
    field :token, :string
    field :token_type, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(stripe_checkout, attrs) do
    stripe_checkout
    |> cast(attrs, [:email, :token, :token_type])
    |> validate_required([:email, :token, :token_type])
    |> unique_constraint(:token)
  end
end
