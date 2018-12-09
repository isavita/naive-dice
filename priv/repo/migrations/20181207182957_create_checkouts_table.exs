defmodule NaiveDice.Repo.Migrations.CreateCheckoutsTable do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :email, :string, null: false
      add :token, :string, null: false
      add :token_type, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:checkouts, [:token])
    create index(:checkouts, [:user_id])
  end
end
