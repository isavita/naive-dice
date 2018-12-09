defmodule NaiveDiceWeb.StripePaymentControllerTest do
  use NaiveDiceWeb.ConnCase
  alias NaiveDice.Bookings
  alias NaiveDice.Bookings.Event
  alias NaiveDice.Bookings.Ticket
  alias NaiveDice.Bookings.TicketSchema
  alias NaiveDice.Repo
  alias NaiveDice.StripePayments.Checkout
  alias NaiveDice.User

  @create_user_attrs %{"email" => "jane@example.com", "password" => "1234"}
  @create_event_attrs %{"title" => "event1"}
  @create_ticket_schema_attrs %{"amount_pennies" => 999, "currency" => "gbp", "available_tickets_count" => 10}

  describe "create/2" do
    setup do
      user = create_user()
      event = create_event()
      ticket_schema = create_ticket_schema(event)
      ticket = create_ticket(event, ticket_schema, user) 

      params = %{
        "stripeEmail" => user.email,
        "stripeToken" => "tok_123",
        "stripeTokenType" => "type1",
        "ticket_id" => ticket.id
      }

      {:ok, user: user, params: params, ticket: ticket}
    end

    test "creates and processes checkout", %{conn: conn, user: user, params: params} do
      conn = conn |> assign(:current_user, user) |> post("/stripe_payments", params)

      assert redirected_to(conn, 302) =~ "/events/"
      assert get_checkout(user).processed
    end

    test "updates the ticket's paid_at to UTC time now", %{conn: conn, user: user, params: params, ticket: ticket} do
      assert is_nil(ticket.paid_at)

      conn |> assign(:current_user, user) |> post("/stripe_payments", params)

      refute is_nil(Bookings.get_ticket!(ticket.id).paid_at)
    end
  end

  defp create_user(attrs \\ @create_user_attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert!()
  end

  defp create_event(attrs \\ @create_event_attrs) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert!()
  end

  defp create_ticket_schema(event, attrs \\ @create_ticket_schema_attrs) do
    {:ok, ticket_schema} =
      attrs
      |> Map.put("event_id", event.id)
      |> Bookings.create_ticket_schema()

    ticket_schema
  end

  defp create_ticket(event, ticket_schema, user) do
    %Ticket{}
    |> Ticket.changeset(%{
      "event_id" => event.id, "user_id" => user.id,
      "ticket_schema_id" => ticket_schema.id, "amount_pennies" => ticket_schema.amount_pennies,
      "currency" => ticket_schema.currency
    })
    |> Repo.insert!()
  end

  defp get_checkout(user) do
    NaiveDice.Repo.get_by!(Checkout, user_id: user.id)
  end
end
