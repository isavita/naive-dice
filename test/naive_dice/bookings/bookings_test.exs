defmodule NaiveDice.BookingsTest do
  use NaiveDice.DataCase
  alias NaiveDice.User
  alias NaiveDice.Bookings
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket
  alias NaiveDice.Bookings.TicketSchema
  alias NaiveDice.Repo

  @create_user_attrs %{"email" => "jane@example.com", "password" => "1234"}
  @create_event_attrs %{"title" => "event1", "description" => "Great event!", "starts_at" => DateTime.utc_now()}
  @valid_ticket_schema_attrs %{"amount_pennies" => 999, "currency" => "gbp", "available_tickets_count" => 10}

  describe "events" do
    setup do
      {:ok, event: create_event()}
    end

    test "get_event!/1 gets the event when the event exists", %{event: event} do
      assert Bookings.get_event!(event.id) == event
    end

    test "get_event!/1 raises an error when the event does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Bookings.get_event!(-1)
      end
    end
  end

  describe "ticket_schemas" do
    setup do
      {:ok, event: create_event()}
    end

    test "create_ticket_schema/1 creates a new ticket schema when correct attributes provided", %{event: event} do
      attrs = Map.put(@valid_ticket_schema_attrs, "event_id", event.id)

      assert {:ok, %TicketSchema{}} = Bookings.create_ticket_schema(attrs)
    end

    test "create_ticket_schema/1 returns an error when incorrect attributes provided" do
      assert {:error, _} = Bookings.create_ticket_schema(%{})
    end

    test "has_available_tickets?/1 returns true if the ticket schema for the event has available tickets", %{event: event} do
      create_ticket_schema(event)

      assert Bookings.has_available_tickets?(event)
    end

    test "has_available_tickets?/1 returns false if the ticket schema for the event does not have available tickets", %{event: event} do
      create_ticket_schema(event, Map.put(@valid_ticket_schema_attrs, "available_tickets_count", 0))

      refute Bookings.has_available_tickets?(event)
    end
  end

  describe "tickets" do
    setup do
      {:ok, event: create_event(), user: create_user()}
    end

    test "create_ticket/3 creates a new ticket when correct attributes provided", %{event: event, user: user} do
      ticket_schema = create_ticket_schema(event)
      attrs = %{"user_id" => user.id}

      assert {:ok, %Ticket{}} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, attrs)
    end

    test "create_ticket/3 returns an error when the ticket schema for the event does not have available tickets", %{event: event, user: user} do
      ticket_schema = create_ticket_schema(event, Map.put(@valid_ticket_schema_attrs, "available_tickets_count", 0))
      attrs = %{"user_id" => user.id}

      assert {:error, "No available tickets!"} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, attrs)
    end

    test "get_user_ticket!/2 gets ticket for a given user and event", %{event: event, user: user} do
      ticket_schema = create_ticket_schema(event)
      ticket = create_ticket(event, ticket_schema, user)

      assert Bookings.get_user_ticket!(user, event) == ticket
    end

    test "update_ticket_to_paid/1 updates `paid_at` to UTC time now", %{event: event, user: user} do
      ticket_schema = create_ticket_schema(event)
      ticket = create_ticket(event, ticket_schema, user)

      assert is_nil(ticket.paid_at)

      ticket = Bookings.update_ticket_to_paid!(ticket)

      refute is_nil(ticket.paid_at)
    end

    test "user_has_ticket?/2 returns true if the user has ticket for the event", %{event: event, user: user} do
      ticket_schema = create_ticket_schema(event)
      create_ticket(event, ticket_schema, user)

      assert Bookings.user_has_ticket?(user, event)
    end

    test "user_has_ticket?/2 returns false if the user does not have ticket for the event", %{event: event, user: user} do
      refute Bookings.user_has_ticket?(user, event)
    end
  end

  defp create_user(attrs \\ @create_user_attrs) do
    %User{} |> User.create_changeset(attrs) |> Repo.insert!()
  end

  defp create_event(attrs \\ @create_event_attrs) do
    %Event{} |> Event.changeset(attrs) |> Repo.insert!()
  end

  defp create_ticket_schema(event, attrs \\ @valid_ticket_schema_attrs) do
    %TicketSchema{}
    |> TicketSchema.changeset(Map.put(attrs, "event_id", event.id))
    |> Repo.insert!()
  end

  defp create_ticket(event, ticket_schema, user) do
    %Ticket{}
    |> Ticket.changeset(%{"event_id" => event.id, "ticket_schema_id" => ticket_schema.id, "user_id" => user.id})
    |> Repo.insert!()
  end
end
