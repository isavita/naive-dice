defmodule NaiveDice.StripePaymentsTest do
  use NaiveDice.DataCase
  alias NaiveDice.User
  alias NaiveDice.StripePayments
  alias NaiveDice.StripePayments.Checkout

  @create_user_attrs %{"email" => "jane@example.com", "password" => "1234"}

  describe "checkouts" do
    @valid_checkout_attrs %{"email" => "jane@example.com", "token" => "abc123", "token_type" => "type1"}

    test "create_checkout!/1 creates a new checkout when all required attributes are provided" do
      user = create_user()
      attrs = Map.put(@valid_checkout_attrs, "user_id", user.id)
      
      assert %Checkout{} = StripePayments.create_checkout!(attrs)
    end

    test "create_checkout!/1 raises an error when not all required attributes are provided" do
      assert_raise Ecto.InvalidChangesetError, fn -> StripePayments.create_checkout!(%{}) end
    end
  end

  def create_user(attrs \\ @create_user_attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> NaiveDice.Repo.insert!()
  end
end
