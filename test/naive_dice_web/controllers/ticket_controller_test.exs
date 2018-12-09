defmodule NaiveDiceWeb.TicketControllerTest do
  use NaiveDiceWeb.ConnCase
  alias NaiveDice.Bookings
  alias NaiveDice.Bookings.Event
  alias NaiveDice.User

  @create_user_attrs %{"email" => "jane@example.com", "password" => "1234"}
  @create_event_attrs %{"title" => "event1"}
  @create_ticket_schema_attrs %{"amount_pennies" => 999, "currency" => "gbp", "available_tickets_count" => 10}

  describe "create/2" do
    setup %{conn: conn} do
      event = create_event()
      user = create_user()
      conn = assign(conn, :current_user, user)
      params = %{"event_id" => event.id}

      {:ok, conn: conn, params: params, event: event}
    end

    test "responds with a success message and creates a new ticket", %{conn: conn, params: params, event: event} do
      create_ticket_schema(event)

      conn = post(conn, "/tickets", params)

      assert redirected_to(conn, 302) == "/events/#{event.id}"
      assert get_flash(conn, :info)
    end

    test "returns an error if the ticket schema for the event does not have available tickets", %{conn: conn, params: params, event: event} do
      create_ticket_schema(event, Map.put(@create_ticket_schema_attrs, "available_tickets_count", 0))

      conn = post(conn, "/tickets", params)

      assert redirected_to(conn, 302) == "/events/#{event.id}"
      assert get_flash(conn, :error)
    end
  end

  defp create_user(attrs \\ @create_user_attrs) do
    %User{} |> User.create_changeset(attrs) |> NaiveDice.Repo.insert!()
  end

  defp create_event(attrs \\ @create_event_attrs) do
    %Event{} |> Event.changeset(attrs) |> NaiveDice.Repo.insert!()
  end

  defp create_ticket_schema(event, attrs \\ @create_ticket_schema_attrs) do
    {:ok, ticket_schema} =
      attrs
      |> Map.put("event_id", event.id)
      |> Bookings.create_ticket_schema()

    ticket_schema
  end
end
