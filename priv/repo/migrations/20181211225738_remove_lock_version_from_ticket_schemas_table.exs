defmodule NaiveDice.Repo.Migrations.RemoveLockVersionFromTicketSchemasTable do
  use Ecto.Migration

  def change do
    alter table(:ticket_schemas) do
      remove :lock_version
    end
  end
end
