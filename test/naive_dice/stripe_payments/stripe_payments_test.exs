defmodule NaiveDice.StripePaymentsTest do
  use NaiveDice.DataCase
  alias NaiveDice.StripePayments
  alias NaiveDice.StripePayments.Customer

  describe "customers" do
    @valid_attrs %{email: "jane_doe@example.com", stripe_token: "abc123", stripe_token_type: "type1"}

    test "create_customer/1 creates a new customer when all required attributes are provided" do
      assert {:ok, %Customer{}} = StripePayments.create_customer(@valid_attrs)
    end
  end
end
