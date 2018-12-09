defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.Repo

  def create(conn, params = %{"event_id" => event_id}) do
    event = Bookings.get_event!(event_id) |> Repo.preload(:ticket_schema)
    ticket_schema = event.ticket_schema
    params = ticket_attrs(params, conn.assigns.current_user) 

    conn = case Bookings.create_ticket_and_update_ticket_schema(event, ticket_schema, params) do
      {:ok, ticket} -> put_flash(conn, :info, "Successfully book a ticket!")
      {:error, reason} -> put_flash(conn, :error, reason)
    end

    redirect(conn, to: Routes.event_path(conn, :show, event_id))
  end
  
  defp ticket_attrs(params, user) do
    Map.put(params, "user_id", user.id)
  end
end
