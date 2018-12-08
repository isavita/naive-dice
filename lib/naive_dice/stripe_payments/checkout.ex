defmodule NaiveDice.StripePayments.Checkout do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.User

  schema "checkouts" do
    field :email, :string
    field :token, :string
    field :token_type, :string
    field :processed, :boolean
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:user_id, :email, :token, :token_type, :processed])
    |> validate_required([:user_id, :email, :token, :token_type])
    |> unique_constraint(:token)
  end
end
