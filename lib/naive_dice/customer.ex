defmodule NaiveDice.Customer do
  use Ecto.Schema
  import Ecto.Changeset


  schema "customers" do
    field :email, :string
    field :stripe_identifier, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:email, :stripe_identifier])
    |> validate_required([:email, :stripe_identifier])
    |> unique_constraint(:stripe_identifier)
  end
end
