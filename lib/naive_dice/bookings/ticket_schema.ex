defmodule NaiveDice.Bookings.TicketSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket


  schema "ticket_schemas" do
    field :amount_pennies, :integer
    field :currency, :string
    field :type, :string
    field :available_tickets_count, :integer
    field :lock_version, :integer, default: 1

    belongs_to :event, Event, foreign_key: :event_id
    has_many :tickets, Ticket

    timestamps()
  end

  @doc false
  def changeset(ticket_schema, attrs) do
    ticket_schema
    |> cast(attrs, [:event_id, :amount_pennies, :currency, :type, :available_tickets_count])
    |> validate_required([:event_id, :available_tickets_count])
    |> optimistic_lock(:lock_version)
  end
end
