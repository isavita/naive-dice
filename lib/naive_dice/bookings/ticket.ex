defmodule NaiveDice.Bookings.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.User
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.TicketSchema
  alias __MODULE__

  @type t :: %Ticket{
          amount_pennies: integer(),
          currency: String.t(),
          paid_at: String.t(),
          user_id: integer(),
          event_id: integer(),
          ticket_schema_id: integer()
        }

  schema "tickets" do
    field :amount_pennies, :integer
    field :currency, :string
    field :paid_at, :utc_datetime

    belongs_to :user, User
    belongs_to :event, Event
    belongs_to :ticket_schema, TicketSchema

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:event_id, :user_id, :ticket_schema_id, :amount_pennies, :currency, :paid_at])
    |> validate_required([:event_id, :user_id, :ticket_schema_id])
  end
end
