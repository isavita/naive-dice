defmodule NaiveDice.Bookings.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.Bookings.Ticket

  schema "events" do
    field :title, :string
    field :description, :string
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    has_many :tickets, Ticket

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :starts_at, :ends_at])
    |> validate_required([:title])
  end
end
