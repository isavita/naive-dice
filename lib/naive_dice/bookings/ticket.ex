defmodule NaiveDice.Bookings.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  alias NaiveDice.Bookings.Event

  schema "tickets" do
    field :email, :string
    field :amount_pennies, :integer
    field :state, :string
    field :paid_at, :utc_datetime
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:email, :event_id, :amount_pennies, :state, :paid_at])
    |> validate_required([:email, :event_id])
  end
end
