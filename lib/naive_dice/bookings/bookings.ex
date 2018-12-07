defmodule NaiveDice.Bookings do
  @moduledoc """
  The Bookings context which combines Event, TicketSchema, and Ticket repos.
  """

  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.TicketSchema
  alias NaiveDice.Bookings.Ticket

  require IEx

  @doc """
  Returns all events in the system.
  """
  def list_events(limit \\ 10) do
    Repo.all(from e in Event, limit: ^limit, preload: [:ticket_schema])
  end

  @doc """
  Gets event with the given id. 

  Raises `Ecto.NoResultsError` if the event does not exists.
  """
  def get_event!(event_id) do
    Repo.get!(Event, event_id)
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

  defp extra_attrs(event, ticket_schema) do
    %{"event_id" => event.id,
      "ticket_schema_id" => ticket_schema.id,
      "amount_pennies" => ticket_schema.amount_pennies,
      "currency" => ticket_schema.currency}
  end
end
