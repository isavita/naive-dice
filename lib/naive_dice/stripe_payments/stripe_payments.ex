defmodule NaiveDice.StripePayments do
  @moduledoc """
  The StripePayments context which is for Checkout and ChargeInfo repos.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias NaiveDice.Bookings
  alias NaiveDice.Repo
  alias NaiveDice.StripePayments.ChargeInfo
  alias NaiveDice.StripePayments.Checkout

  @stripe_api Application.get_env(:naive_dice, :stripe_api)

  @doc """
  Creates and processes checkout base of attributes recieved from stripe on handling checkout callback.
  """
  def process_checkout(user, ticket, attrs) do
    Multi.new()
    |> update_ticket_to_paid(ticket)
    |> Multi.insert(:checkout, Checkout.changeset(%Checkout{}, stripe_checkout_attrs(user, attrs)))
    |> call_charge_stripe_api(ticket) 
    |> Repo.transaction()
    |> case do
      {:ok, %{checkout: checkout, call_charge_stripe_api: charge_data}} ->
        {:ok, %{checkout: checkout, charge_data: charge_data}}
      {:error, _op, reason, _} ->
        {:error, reason}
    end
  end

  @doc """
  Creates a checkout.
  """
  def create_checkout!(attrs) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert!()
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

  defp update_ticket_to_paid(multi, ticket) do
    multi
    |> Multi.run(:update_ticket_to_paid, fn _repo, _changes ->
      Bookings.update_ticket_to_paid(ticket)
    end)
  end

  defp call_charge_stripe_api(multi, ticket) do
    multi
    |> Multi.run(:call_charge_stripe_api, fn _repo, %{checkout: checkout} ->
      case charge_checkout(checkout, ticket) do
        {:ok, charge_data} -> {:ok, charge_data}
        {:error, _} -> {:error, "We couldn't process your payment! Please, try again!"}
      end
    end)
  end

  defp charge_checkout(checkout, ticket) do
    @stripe_api.create_idempotent_charge(
      checkout.token, ticket.amount_pennies, ticket.currency, idempotency_key(ticket)
    )
  end

  defp stripe_checkout_attrs(user, attrs) do
    %{
      "user_id" => user.id,
      "email" => attrs["stripeEmail"],
      "token" => attrs["stripeToken"],
      "token_type" => attrs["stripeTokenType"]
    }
  end

  defp charge_info_attrs(charge_data) do
    %{
      "charge" => extract_simple_attrs(charge_data),
      "outcome" => extract_simple_attrs(charge_data["outcome"]),
      "source" => extract_simple_attrs(charge_data["source"])
    }
  end

  defp extract_simple_attrs(nil), do: %{}
  defp extract_simple_attrs(map) do
    for {key, value} <- Map.to_list(map), !is_map(value), into: %{}, do: {key, value}
  end

  defp idempotency_key(ticket), do: "ticket-key#{ticket.id}"
end
