defmodule NaiveDice.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :session_secret, :string

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
