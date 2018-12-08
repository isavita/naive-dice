defmodule NaiveDice.Bookings.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.User
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.TicketSchema

  schema "tickets" do
    field :amount_pennies, :integer
    field :currency, :string
    field :state, :string # TODO: review the need of this field
    field :paid_at, :utc_datetime

    belongs_to :user, User
    belongs_to :event, Event
    belongs_to :ticket_schema, TicketSchema

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:event_id, :user_id, :ticket_schema_id, :amount_pennies, :currency, :state, :paid_at])
    |> validate_required([:event_id, :user_id, :ticket_schema_id])
  end
end
