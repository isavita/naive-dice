defmodule NaiveDice.StripePayments.Checkout do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.User
  alias __MODULE__

  @type t :: %Checkout{
          email: String.t(),
          token: String.t(),
          token_type: String.t(),
          user_id: pos_integer()
        }

  schema "checkouts" do
    field :email, :string
    field :token, :string
    field :token_type, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:user_id, :email, :token, :token_type])
    |> validate_required([:user_id, :email, :token, :token_type])
    |> unique_constraint(:token)
  end
end
