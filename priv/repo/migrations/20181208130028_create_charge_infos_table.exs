defmodule NaiveDice.Repo.Migrations.CreateChargeInfosTable do
  use Ecto.Migration

  def change do
    create table(:charge_infos) do
      add :charge, :map
      add :outcome, :map
      add :source, :map
      add :checkout_id, references(:checkouts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:charge_infos, [:checkout_id])
  end
end
