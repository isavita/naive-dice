defmodule NaiveDiceWeb.StripePaymentController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.StripePayments

  def create(conn, params = %{"ticket_id" => ticket_id}) do
    user = conn.assigns.current_user
    ticket = Bookings.get_ticket!(ticket_id)

    # TODO: Move the whole block of code that is inside the transaction to a method
    # start transaction
    checkout = stripe_checkout_attrs(params, user) |> StripePayments.create_checkout!()
    # TODO: Add handling of API call response {:error, ...}
    {:ok, charge_data} = StripePayments.charge_checkout(checkout, ticket)
    charge_info = StripePayments.create_charge_info!(checkout, charge_data)
    # TODO: Add checks for charge_info["netwrok_status"] and different behaviour for the update of the ticket and checkout
    Bookings.update_ticket_to_paid!(ticket)
    StripePayments.update_checkout_to_processed!(checkout)
    # end transaction

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
