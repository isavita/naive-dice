defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings

  def create(conn, params = %{"event_id" => event_id, "ticket_schema_id" => ticket_schema_id}) do
    current_user_id = conn.assigns.current_user.id

    {:ok, ticket} = Bookings.create_ticket(Map.put(params, "user_id", current_user_id))

    redirect(conn, to: Routes.event_path(conn, :show, event_id))
  end
end
