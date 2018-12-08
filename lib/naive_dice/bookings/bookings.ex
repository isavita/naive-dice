defmodule NaiveDice.Bookings do
  @moduledoc """
  The Bookings context which combines Event, TicketSchema, and Ticket repos.
  """

  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.TicketSchema
  alias NaiveDice.Bookings.Ticket

  @doc """
  Returns all events in the system.
  """
  def list_events(limit \\ 10) do
    Repo.all(from e in Event, limit: ^limit, preload: [:ticket_schema])
  end

  @doc """
  Gets event if exists. 

  Raises `Ecto.NoResultsError` if the event does not exist.
  """
  def get_event!(event_id) do
    Repo.get!(Event, event_id) |> Repo.preload(:ticket_schema)
  end

  @doc """
  Returns all tickets for a given event.
  """
  def list_tickets(event_id) do
    Repo.all(Ticket)
  end

  @doc """
  Creates a ticket schema.
  """
  def create_ticket_schema(attrs) do
    %TicketSchema{}
    |> TicketSchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a ticket.
  """
  def create_ticket(event, ticket_schema, attrs) do
    %Ticket{}
    |> Ticket.changeset(Map.merge(attrs, extra_attrs(event, ticket_schema)))
    |> Repo.insert()
  end

  @doc """
  Updates a ticket's `paid_at` column to UTC time now.
  """
  def update_ticket_to_paid!(ticket) do
    ticket
    |> Ticket.changeset(%{"paid_at" => DateTime.utc_now(), "state" => "paid"})
    |> Repo.update!()
  end

  @doc """
  Gets a ticket for a given user and event.

  Gets nil if a ticket for a given user and event does not exist.
  """
  def get_user_ticket!(user, event) do
    Repo.get_by!(Ticket, user_id: user.id, event_id: event.id)
  end

  @doc """
  Gets ticket with the given id. 

  Raises `Ecto.NoResultsError` if the ticket does not exist.
  """
  def get_ticket!(ticket_id) do
    Repo.get!(Ticket, ticket_id)
  end

  @doc """
  Returns `true` if the event has available tickets.
  """
  def has_available_tickets?(event) do
    Repo.exists?(from ts in TicketSchema, where: ts.event_id == ^event.id and ts.available_tickets_count > 0)
  end

  @doc """
  Returns `true` if an user has ticket for an event.
  """
  def user_has_ticket?(user, event, opts \\ []) do
    if Keyword.get(opts, :paid) do
      Repo.exists?(from t in Ticket, where: t.user_id == ^user.id and t.event_id == ^event.id and not is_nil(t.paid_at))
    else
      Repo.exists?(from t in Ticket, where: t.user_id == ^user.id and t.event_id == ^event.id)
    end
  end

  defp extra_attrs(event, ticket_schema) do
    %{"event_id" => event.id,
      "ticket_schema_id" => ticket_schema.id,
      "amount_pennies" => ticket_schema.amount_pennies,
      "currency" => ticket_schema.currency}
  end
end
