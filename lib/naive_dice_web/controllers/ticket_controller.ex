defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings

  def create(conn, params = %{"event_id" => event_id}) do
    current_user_id = conn.assigns.current_user.id
    event = Bookings.get_event!(event_id)
    ticket_schema = event.ticket_schema

    # TODO: Add check for available_tickets_count
    {:ok, ticket} = Bookings.create_ticket(event, ticket_schema, Map.put(params, "user_id", current_user_id))
    # TODO: Add flash messages for {:error, changeset} 
    # TODO: Update ticket_schema available_tickets_count

    redirect(conn, to: Routes.event_path(conn, :show, event_id))
  end
end
