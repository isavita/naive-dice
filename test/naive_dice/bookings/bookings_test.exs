defmodule NaiveDice.BookingsTest do
  use NaiveDice.DataCase
  alias NaiveDice.Bookings
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket

  @create_event_attrs %{title: "event1", description: "Great event!", starts_at: DateTime.utc_now()}

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

  describe "tickets" do
    @valid_attrs %{email: "jane_doe@example.com", amount_pennies: 999}

    test "create_ticket/1 creates a new ticket when all required attributes are provided" do
      event = create_event()
      attrs = Map.put(@valid_attrs, :event_id, event.id)

      assert {:ok, %Ticket{}} = Bookings.create_ticket(attrs)
    end
  end

  def create_event(attrs \\ @create_event_attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end
end
