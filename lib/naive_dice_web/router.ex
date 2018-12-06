defmodule NaiveDiceWeb.Router do
  use NaiveDiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NaiveDiceWeb do
    pipe_through :browser

    get "/", EventController, :index
    resources "events", EventController, only: [:index, :show]
    resources "tickets", TicketController, only: [:create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", NaiveDiceWeb do
  #   pipe_through :api
  # end
end
