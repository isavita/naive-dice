defmodule StripeBook.Repo.Migrations.CreateTicketsTable do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :user_id, references(:users), null: false
      add :event_id, references(:events), null: false
      add :ticket_schema_id, references(:ticket_schemas), null: false
      add :amount_pennies, :integer
      add :currency, :string, size: 3
      add :state, :string, default: "created"
      add :paid_at, :utc_datetime

      timestamps()
    end

    create index(:tickets, [:user_id])
    create index(:tickets, [:event_id])
    create index(:tickets, [:ticket_schema_id])
  end
end
