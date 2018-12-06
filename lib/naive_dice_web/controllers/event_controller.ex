defmodule NaiveDiceWeb.EventController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings

  def index(conn, _params) do
    events = Bookings.list_events()

    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Bookings.get_event!(id)
    stripe_api_key = System.get_env("STRIPE_API_PUBLISHABLE_KEY")

    render(conn, "show.html", event: event, csrf_token: get_csrf_token(), stripe_api_key: stripe_api_key)
  end
end
