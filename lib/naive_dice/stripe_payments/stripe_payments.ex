defmodule NaiveDice.StripePayments do
  @moduledoc """
  The StripePayments context which is for Checkout and Charge repos.
  """

  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.StripePayments.Checkout

  @doc """
  Creates a checkout.
  """
  def create_checkout!(attrs) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a checkout's `processed` column to `true`.
  """
  def update_checkout_to_processed!(checkout) do
    checkout
    |> Checkout.changeset(%{"processed" => true})
    |> Repo.update!()
  end

  @doc """
  Gets checkout if exists.

  Raises `Ecto.NoResultsError` if the event does not exist.
  """
  def get_checkout!(checkout_id) do
    Repo.get!(Checkout, checkout_id)
  end

  @doc """
  Creates a stripe charge.
  """
  def create_charge(checkout, ticket) do
    Charge.create(%{
      amount: ticket.amount_pennies,
      currency: ticket.currency,
      source: checkout.token
    })
  end

  @doc """
  Calls stripe charge API.
  """
  def exec_stripe_charge(_stripe_charge), do: nil
end
