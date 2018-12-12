defmodule NaiveDice.StripeApi.HTTPClient do
  require Stripe

  @charge_endpoint "charges"

  def create_idempotent_charge(source_token, amount, currency, idempotency_key) do
    Stripe.API.request(
      %{source: source_token, amount: amount, currency: currency},
      :post,
      @charge_endpoint,
      %{"Idempotency-Key" => idempotency_key},
      connect_account: account().id
    )
  end

  defp account do
    {:ok, account} = Stripe.Account.retrieve()
    account
  end
end
