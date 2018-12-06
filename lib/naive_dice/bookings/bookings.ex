defmodule NaiveDice.Bookings do
  @moduledoc """
  The Bookings context which combines Event and Ticket repos.
  """

  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket
  alias NaiveDice.Bookings.Customer


  @doc """
  Returns all events in the system.
  """
  def list_events do
    Repo.all(Event)
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
  Creates a ticket.
  """
  def create_ticket(attrs) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end
end
