defmodule NaiveDiceWeb.StripePaymentController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.StripePayments

  def create(conn, params = %{"ticket_id" => ticket_id}) do
    ticket = Bookings.get_ticket!(ticket_id)

    {:ok, customer} = create_customer(params)
    charge = StripePayments.create_charge(customer, ticket)

    IO.inspect charge

    redirect(conn, to: Routes.event_path(conn, :show, ticket.event_id))
  end

  defp create_customer(params) do
    params
    |> customer_attrs()
    |> StripePayments.create_customer()
  end

  defp customer_attrs(params) do
    %{
      email: params["stripeEmail"],
      stripe_token: params["stripeToken"],
      stripe_token_type: params["stripeTokenType"]
    }
  end
end
