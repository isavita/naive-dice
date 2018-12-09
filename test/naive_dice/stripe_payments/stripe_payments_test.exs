defmodule NaiveDice.StripePaymentsTest do
  use NaiveDice.DataCase
  alias NaiveDice.User
  alias NaiveDice.StripePayments
  alias NaiveDice.StripePayments.Checkout
  alias NaiveDice.StripePayments.ChargeInfo
  alias NaiveDice.Repo

  describe "checkouts" do
    setup do
      user = create_user(%{"email" => "jane@example.com", "password" => "1234"})
      checkout_attrs = %{"email" => "jane@example.com", "token" => "abc123", "token_type" => "type1", "user_id" => user.id}

      {:ok, checkout_attrs: checkout_attrs}
    end

    test "create_checkout!/1 creates a new checkout when correct attributes provided", %{checkout_attrs: checkout_attrs} do
      assert %Checkout{} = StripePayments.create_checkout!(checkout_attrs)
    end

    test "create_checkout!/1 raises an error when incorrect attributes provided" do
      assert_raise Ecto.InvalidChangesetError, fn -> StripePayments.create_checkout!(%{}) end
    end
  end

  describe "charge info" do
    setup do
      user = create_user(%{"email" => "jane@example.com", "password" => "1234"})
      checkout_attrs = %{"email" => "jane@example.com", "token" => "abc123", "token_type" => "type1", "user_id" => user.id}

      {:ok, checkout: create_checkout(checkout_attrs)}
    end

    test "create_charge_info!/2 creates a new charge info when correct attributes provided", %{checkout: checkout} do
      charge_data = %{source: %{}, outcome: %{}}

      assert %ChargeInfo{} = StripePayments.create_charge_info!(checkout, charge_data)
    end

    test "create_charge_info!/2 raises an error when incorrect attributes provided", %{checkout: checkout} do
      assert_raise KeyError, fn -> StripePayments.create_charge_info!(checkout, %{}) end
    end
  end

  def create_user(attrs) do
    %User{} |> User.create_changeset(attrs) |> Repo.insert!()
  end

  def create_checkout(attrs) do
    %Checkout{} |> Checkout.changeset(attrs) |> Repo.insert!()
  end
end
