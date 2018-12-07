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

      assert {:ok, %Ticket{}} = Bookings.create_ticket(event, ticket_schema, attrs)
    end
  end

  def create_user(attrs \\ @create_user_attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end

  def create_event(attrs \\ @create_event_attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end

  def create_ticket_schema(event, attrs \\ @valid_ticket_schema_attrs) do
    %TicketSchema{}
    |> TicketSchema.changeset(Map.put(attrs, "event_id", event.id))
    |> NaiveDice.Repo.insert!()
  end
end
