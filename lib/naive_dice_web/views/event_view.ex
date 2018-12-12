defmodule NaiveDiceWeb.EventView do
  use NaiveDiceWeb, :view
  alias NaiveDice.Bookings

  @currency_symbols %{"gbp" => "£", "usd" => "$", "eur" => "€"}

  def formatted_amount(ticket_schema) do
    if is_nil(ticket_schema.amount_pennies) || ticket_schema.amount_pennies == 0 do
      "FREE"
    else
      "#{@currency_symbols[ticket_schema.currency]}#{amount(ticket_schema)}"
    end
  end

  def has_available_tickets?(event) do
    Bookings.has_available_tickets?(event)
  end

  def user_has_ticket?(user, event) do
    Bookings.user_has_ticket?(user, event)
  end

  def user_has_paid_ticket?(user, event) do
    Bookings.user_has_ticket?(user, event, paid: true)
  end

  def get_user_ticket(user, event) do
    Bookings.get_user_ticket!(user, event)
  end

  def csrf_token, do: Phoenix.Controller.get_csrf_token()

  def stripe_api_key, do: System.get_env("STRIPE_API_PUBLISHABLE_KEY")

  defp amount(ticket_schema), do: ticket_schema.amount_pennies / 100
end
