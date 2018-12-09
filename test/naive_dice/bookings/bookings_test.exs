defmodule NaiveDice.BookingsTest do
  use NaiveDice.DataCase
  alias NaiveDice.User
  alias NaiveDice.Bookings
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket
  alias NaiveDice.Bookings.TicketSchema

  @create_user_attrs %{"email" => "jane@example.com", "password" => "1234"}
  @create_event_attrs %{"title" => "event1", "description" => "Great event!", "starts_at" => DateTime.utc_now()}
  @valid_ticket_schema_attrs %{"amount_pennies" => 999, "currency" => "gbp", "available_tickets_count" => 10}
  @valid_ticket_attrs %{"state" => "created"}

  describe "events" do
    test "get_event!/1 gets the event when the event exists" do
      %Event{id: id} = create_event()

      assert %Event{id: id} = Bookings.get_event!(id)
    end

    test "get_event!/1 raises an error when the event does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Bookings.get_event!(-1)
      end
    end
  end

  describe "ticket_schemas" do
    test "create_ticket_schema/1 creates a new ticket schema when all required attributes are provided" do
      event = create_event(Map.put(@create_event_attrs, "title", "event2"))
      attrs = Map.put(@valid_ticket_schema_attrs, "event_id", event.id)

      assert {:ok, %TicketSchema{}} = Bookings.create_ticket_schema(attrs)
    end
  end

  describe "tickets" do
    test "create_ticket/3 creates a new ticket when all required attributes are provided" do
      user = create_user()
      event = create_event(Map.put(@create_event_attrs, "title", "event3"))
      ticket_schema = create_ticket_schema(event)
      attrs = Map.put(@valid_ticket_attrs, "user_id", user.id)

      assert {:ok, %Ticket{}} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, attrs)
    end

    test "create_ticket/3 returns an error when the ticket schema does not have available tickets" do
      user = create_user()
      event = create_event(Map.put(@create_event_attrs, "title", "event4"))
      ticket_schema = create_ticket_schema(event, Map.put(@valid_ticket_schema_attrs, "available_tickets_count", 0))
      attrs = Map.put(@valid_ticket_attrs, "user_id", user.id)

      assert {:error, "No available tickets!"} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, attrs)
    end

    test "get_user_ticket!/2 gets ticket for a given user and event" do
      user = create_user()
      event = create_event()
      ticket_schema = create_ticket_schema(event)
      ticket_attrs = Map.put(@valid_ticket_attrs, "user_id", user.id)
      {:ok, ticket} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, ticket_attrs)

      assert ticket == Bookings.get_user_ticket!(user, event)
    end

    test "update_ticket_to_paid/1 updates `paid_at` to UTC time now" do
      user = create_user()
      event = create_event()
      ticket_schema = create_ticket_schema(event)
      ticket_attrs = Map.put(@valid_ticket_attrs, "user_id", user.id)
      {:ok, ticket} = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, ticket_attrs)

      assert is_nil(ticket.paid_at)

      ticket = Bookings.update_ticket_to_paid!(ticket)

      refute is_nil(ticket.paid_at)
    end


    test "has_available_tickets?/1 returns true if the event has available tickets" do
      event = create_event()
      ticket_schema = create_ticket_schema(event)

      assert Bookings.has_available_tickets?(event) == true
    end

    test "has_available_tickets?/1 returns false if the event does not have available tickets" do
      event = create_event()
      ticket_schema = create_ticket_schema(event, Map.put(@valid_ticket_schema_attrs, "available_tickets_count", 0))

      assert Bookings.has_available_tickets?(event) == false
    end

    test "user_has_ticket?/2 returns true if the user has ticket for the event" do
      user = create_user()
      event = create_event()
      ticket_schema = create_ticket_schema(event)
      ticket_attrs = Map.put(@valid_ticket_attrs, "user_id", user.id)
      ticket = Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, ticket_attrs)

      assert Bookings.user_has_ticket?(user, event) == true
    end

    test "user_has_ticket?/2 returns false if the user does not have ticket for the event" do
      user = create_user()
      event = create_event()

      assert Bookings.user_has_ticket?(user, event) == false
    end
  end

  defp create_user(attrs \\ @create_user_attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end

  defp create_event(attrs \\ @create_event_attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end

  defp create_ticket_schema(event, attrs \\ @valid_ticket_schema_attrs) do
    %TicketSchema{}
    |> TicketSchema.changeset(Map.put(attrs, "event_id", event.id))
    |> NaiveDice.Repo.insert!()
  end
end
