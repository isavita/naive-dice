defmodule NaiveDice.StripeApi.InMemory do
  def create_idempotent_charge(_source_token, amount, currency, _idempotency_key) do
    {:ok, %{
   "source" => %{
     "address_city" => nil,
     "address_country" => nil,
     "address_line1" => nil,
     "address_line1_check" => nil,
     "address_line2" => nil,
     "address_state" => nil,
     "address_zip" => nil,
     "address_zip_check" => nil,
     "brand" => "Visa",
     "country" => "US",
     "customer" => nil,
     "cvc_check" => "pass",
     "dynamic_last4" => nil,
     "exp_month" => 2,
     "exp_year" => 2021,
     "fingerprint" => "y6ZYvX4xLyX66f29",
     "funding" => "credit",
     "id" => "card_1DffGfDgTIQFOsYvEWMxACk5",
     "last4" => "4242",
     "metadata" => %{},
     "name" => "a@a.com",
     "object" => "card",
     "tokenization_method" => nil
   },
   "on_behalf_of" => nil,
   "application" => nil,
   "customer" => nil,
   "balance_transaction" => "txn_1DffMNDgTIQFOsYvE4piuiLx",
   "review" => nil,
   "created" => 1544412187,
   "statement_descriptor" => nil,
   "source_transfer" => nil,
   "amount" => amount,
   "transfer_group" => nil,
   "payment_intent" => nil,
   "captured" => true,
   "outcome" => %{
     "network_status" => "approved_by_network",
     "reason" => nil,
     "risk_level" => "normal",
     "risk_score" => 59,
     "seller_message" => "Payment complete.",
     "type" => "authorized"
   },
   "id" => "ch_1DffMNDgTIQFOsYvOwi9V69y",
   "amount_refunded" => 0,
   "receipt_number" => nil,
   "currency" => currency,
   "refunds" => %{
     "data" => [],
     "has_more" => false,
     "object" => "list",
     "total_count" => 0,
     "url" => "/v1/charges/ch_1DffMNDgTIQFOsYvOwi9V69y/refunds"
   },
   "paid" => true,
   "application_fee" => nil,
   "failure_code" => nil,
   "failure_message" => nil,
   "invoice" => nil,
   "shipping" => nil,
   "status" => "succeeded",
   "refunded" => false,
   "fraud_details" => %{},
   "description" => nil,
   "metadata" => %{},
   "livemode" => false,
   "object" => "charge",
   "dispute" => nil,
   "order" => nil,
   "destination" => nil,
   "receipt_email" => nil
 }}
  end
end
