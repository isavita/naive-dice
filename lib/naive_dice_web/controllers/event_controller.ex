defmodule NaiveDiceWeb.EventController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings

  def index(conn, _params) do
    events = Bookings.list_events()

    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Bookings.get_event!(id)

    render(conn, "show.html", event: event)
  end
end
