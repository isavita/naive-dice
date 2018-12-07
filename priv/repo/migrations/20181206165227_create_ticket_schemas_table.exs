defmodule NaiveDice.Repo.Migrations.CreateTicketSchemasTable do
  use Ecto.Migration

  def change do
    create table(:ticket_schemas) do
      add :event_id, references(:events)
      add :amount_pennies, :integer
      add :currency, :string, size: 3
      add :type, :string, null: false, default: "standard"
      add :available_tickets_count, :integer, null: false

      timestamps()
    end

    create index(:ticket_schemas, [:event_id])
  end
end
