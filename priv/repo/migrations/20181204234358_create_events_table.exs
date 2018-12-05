defmodule StripeBook.Repo.Migrations.CreateEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, null: false
      add :description, :text
      add :starts_at, :utc_datetime
      add :ends_at, :utc_datetime

      timestamps()
    end
  end
end
