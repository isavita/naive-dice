defmodule NaiveDiceWeb.EventController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.Repo

  def index(conn, _params) do
    events = Bookings.list_events()

    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Bookings.get_event!(id) |> Repo.preload(:ticket_schema)

    render(conn, "show.html", event: event)
  end
end
