defmodule NaiveDice.Repo.Migrations.CreateCustomersTable do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string, null: false
      add :stripe_token, :string, null: false
      add :stripe_token_type, :string, null: false

      timestamps()
    end

    create unique_index(:customers, [:stripe_token])
  end
end
