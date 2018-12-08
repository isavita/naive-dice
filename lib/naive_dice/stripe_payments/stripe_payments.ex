defmodule NaiveDice.StripePayments do
  @moduledoc """
  The StripePayments context which is for Checkout and ChargeInfo repos.
  """

  require Stripe
  import Ecto.Query, warn: false
  alias NaiveDice.Repo
  alias NaiveDice.StripePayments.ChargeInfo
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
  Creates a charge_info.
  """
  def create_charge_info!(checkout, charge_data) do
    %ChargeInfo{}
    |> ChargeInfo.changeset(Map.put(charge_info_attrs(charge_data), "checkout_id", checkout.id))
    |> Repo.insert!()
  end

  @doc """
  Charges a checkout by calling Stripe API.
  """
  def charge_checkout(checkout, ticket) do
    Stripe.Charge.create(%{
      amount: ticket.amount_pennies,
      currency: ticket.currency,
      source: checkout.token
    })
  end

  defp charge_info_attrs(charge_data) do
    %{
      "charge" => extract_simple_attrs(charge_data),
      "outcome" => extract_simple_attrs(charge_data.outcome),
      "source" => extract_simple_attrs(charge_data.source)
    }
  end

  defp extract_simple_attrs(map) do
    for {key, value} <- Map.to_list(map), !is_map(value) && key != :__struct__, into: %{}, do: {Atom.to_string(key), value}
  end
end
