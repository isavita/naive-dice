defmodule NaiveDice.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Doorman.Auth.Bcrypt, only: [hash_password: 1]
  alias __MODULE__

  @type t :: %User{
          email: String.t(),
          hashed_password: String.t(),
          session_secret: String.t()
        }

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :session_secret, :string

    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_confirmation(:password)
    |> validate_required([:email, :password])
    |> hash_password
  end
end
