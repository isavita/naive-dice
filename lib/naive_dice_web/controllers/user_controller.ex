defmodule NaiveDiceWeb.UserController do
  use NaiveDiceWeb, :controller
  alias Doorman.Auth.Secret
  alias NaiveDice.User
  alias NaiveDice.Repo

  def new(conn, _params) do
    changeset = User.create_changeset(%User{})
    conn |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset =
      %User{}
      |> User.create_changeset(user_params)
      |> Secret.put_session_secret()

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn |> redirect(to: "/")
      {:error, changeset} ->
        conn |> render("new.html", changeset: changeset)
    end
  end
end
