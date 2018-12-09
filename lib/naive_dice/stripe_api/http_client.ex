defmodule NaiveDice.StripeApi.HTTPClient do
  require Stripe

  def create_charge(source_token, amount, currency) do
    Stripe.Charge.create(%{
      source: source_token,
      amount: amount,
      currency: currency
    })
  end
end
