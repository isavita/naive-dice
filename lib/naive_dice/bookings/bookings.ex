defmodule NaiveDice.Bookings do
  @moduledoc """
  The Bookings context which combines Event, TicketSchema, and Ticket repos.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
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
    Repo.get!(Event, event_id)
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
  Creates a ticket and updates ticket schema's available tickets count.
  """
  def create_ticket_and_update_ticket_schema(event, ticket_schema, attrs) do
    Multi.new()
    |> valid_ticket_schema(ticket_schema)
    |> decrement_available_tickets_count(ticket_schema)
    |> Multi.insert(:ticket, create_ticket(event, ticket_schema, attrs))
    |> Repo.transaction()
    |> case do
      {:ok, %{ticket: ticket, decrement_available_tickets_count: _, valid_ticket_schema: _}} ->
        {:ok, ticket}

      {:error, _operation, reason, _changes} ->
        {:error, reason}
    end
  end

  @doc """
  Updates a ticket's `paid_at` column to UTC time now.
  """
  def update_ticket_to_paid(ticket) do
    ticket
    |> Ticket.changeset(%{"paid_at" => DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Gets a ticket for a given user and event.

  Gets nil if a ticket for a given user and event does not exist.
  """
  def get_user_ticket!(user, event) do
    Repo.get_by!(Ticket, user_id: user.id, event_id: event.id)
  end

  @doc """
  Gets only ticket that it is not paid and belongs to given user. 

  Raises `Ecto.NoResultsError` if the ticket does not exist.
  """
  def get_user_unpaid_ticket_by_id!(user, ticket_id) do
    Repo.one!(
      from t in Ticket, where: t.id == ^ticket_id and t.user_id == ^user.id and is_nil(t.paid_at)
    )
  end

  @doc """
  Returns `true` if the event has available tickets.
  """
  def has_available_tickets?(event) do
    Repo.exists?(
      from ts in TicketSchema, where: ts.event_id == ^event.id and ts.available_tickets_count > 0
    )
  end

  @doc """
  Returns `true` if an user has ticket for an event.
  """
  def user_has_ticket?(user, event, opts \\ []) do
    if Keyword.get(opts, :paid) do
      Repo.exists?(
        from t in Ticket,
          where: t.user_id == ^user.id and t.event_id == ^event.id and not is_nil(t.paid_at)
      )
    else
      Repo.exists?(from t in Ticket, where: t.user_id == ^user.id and t.event_id == ^event.id)
    end
  end

  defp valid_ticket_schema(multi, ticket_schema) do
    multi
    |> Multi.run(:valid_ticket_schema, fn _repo, changes ->
      if ticket_schema.available_tickets_count > 0,
        do: {:ok, changes},
        else: {:error, "No available tickets!"}
    end)
  end

  defp decrement_available_tickets_count(multi, ticket_schema) do
    multi
    |> Multi.run(:decrement_available_tickets_count, fn _repo, changes ->
      Repo.transaction(fn ->
        ticket_schema_locked =
          Repo.one(from ts in TicketSchema, where: ts.id == ^ticket_schema.id, lock: "FOR UPDATE")

        ticket_schema_locked
        |> TicketSchema.changeset(%{
          "available_tickets_count" => ticket_schema_locked.available_tickets_count - 1
        })
        |> Repo.update()
      end)
    end)
  end

  defp create_ticket(event, ticket_schema, attrs) do
    %Ticket{} |> Ticket.changeset(Map.merge(attrs, extra_attrs(event, ticket_schema)))
  end

  defp extra_attrs(event, ticket_schema) do
    %{
      "event_id" => event.id,
      "ticket_schema_id" => ticket_schema.id,
      "amount_pennies" => ticket_schema.amount_pennies,
      "currency" => ticket_schema.currency
    }
  end
end
