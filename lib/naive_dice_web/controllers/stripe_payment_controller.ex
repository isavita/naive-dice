defmodule NaiveDiceWeb.StripePaymentController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.StripePayments

  def create(conn, params = %{"ticket_id" => ticket_id}) do
    user = conn.assigns.current_user
    ticket = Bookings.get_ticket!(ticket_id)

    checkout =
      stripe_checkout_attrs(params, user)
      |> StripePayments.create_checkout!()
    # start transaction
    # 2) make a call to stripe API to charge
    # 3) update ticket to paid with DateTime.utc_now()
    StripePayments.update_to_processed!(checkout)
    # end transaction
    # store the information from the call from step (2)
    # {:ok, customer} = create_customer(params)
    # charge = StripePayments.create_charge(customer, ticket)

    redirect(conn, to: Routes.event_path(conn, :show, ticket.event_id))
  end

  defp stripe_checkout_attrs(params, user) do
    %{
      "email" => params["stripeEmail"],
      "token" => params["stripeToken"],
      "token_type" => params["stripeTokenType"],
      "user_id" => user.id
    }
  end
end
