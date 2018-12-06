defmodule NaiveDice.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :hashed_password, :string
      add :session_secret, :string

      timestamps()
    end
  end
end
