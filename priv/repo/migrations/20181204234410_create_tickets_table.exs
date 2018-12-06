defmodule StripeBook.Repo.Migrations.CreateTicketsTable do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :email, :string, null: false
      add :event_id, references(:events), null: false
      add :amount_pennies, :integer
      add :currency, :string, size: 3
      add :state, :string, default: "created"
      add :paid_at, :utc_datetime

      timestamps()
    end

    create unique_index(:tickets, [:email])
  end
end
