defmodule NaiveDice.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]


  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :session_secret, :string

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> hash_password
  end
end
