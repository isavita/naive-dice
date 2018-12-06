defmodule NaiveDice.Bookings.TicketSchema do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket


  schema "ticket_schema" do
    field :amount_pennies, :integer
    field :currency, :string
    field :type, :string

    belongs_to :event, Event
    has_many :tickets, Ticket

    timestamps()
  end

  @doc false
  def changeset(ticket_schema, attrs) do
    ticket_schema
    |> cast(attrs, [:amount_pennies, :currency, :event_id, :type])
    |> validate_required([:event_id])
  end
end
