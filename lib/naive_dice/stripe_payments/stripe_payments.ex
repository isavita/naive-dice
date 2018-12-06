defmodule NaiveDice.StripePayments do
  @moduledoc """
  The StripePayments context which is for Customer and Charge repos.
  """

  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.StripePayments.Customer

  @doc """
  Creates a customer.
  """
  def create_customer(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a stripe charge.
  """
  def create_charge(customer, ticket) do
    Charge.create(%{
      amount: ticket.amount_pennies,
      currency: ticket.currency,
      source: customer.stripe_token
    })
  end

  @doc """
  Calls stripe charge API.
  """
  def exec_stripe_charge(_stripe_charge), do: nil
end
