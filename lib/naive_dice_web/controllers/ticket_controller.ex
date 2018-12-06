defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings

  def create(conn, params = %{"event_id" => event_id}) do
    event = Bookings.get_event!(event_id)

    {:ok, _} = Bookings.create_ticket(Map.put(params, "email", "jane@example.com"))

    redirect(conn, to: Routes.event_path(conn, :show, event))
  end
end
