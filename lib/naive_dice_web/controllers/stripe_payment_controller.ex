defmodule NaiveDiceWeb.StripePaymentController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.Bookings
  alias NaiveDice.StripePayments

  def create(conn, params = %{"ticket_id" => ticket_id}) do
    user = conn.assigns.current_user
    ticket = Bookings.get_ticket!(ticket_id)

    conn = case StripePayments.process_checkout(user, ticket, params) do
      {:ok, %{checkout: checkout, charge_data: charge_data}} ->
        # TODO: handle errors on charge info
        StripePayments.create_charge_info!(checkout, charge_data)
        Bookings.update_ticket_to_paid!(ticket)
        put_flash(conn, :info, "Successful payment!")
      {:error, reason} ->
        put_flash(conn, :error, reason)
    end

    redirect(conn, to: Routes.event_path(conn, :show, ticket.event_id))
  end
end
