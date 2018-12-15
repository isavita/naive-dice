defmodule NaiveDice.StripeApi.HTTPClient do
  require Stripe

  @charge_endpoint "charges"

  @spec create_idempotent_charge(String.t(), integer(), String.t(), String.t()) ::
          {:ok, map()} | {:error, any()}
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
    case Stripe.Account.retrieve() do
      {:ok, account} -> account
      {:error, reason} -> raise "cannot connect to Stripe API account"
    end
  end
end
