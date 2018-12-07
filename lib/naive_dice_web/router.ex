defmodule NaiveDiceWeb.Router do
  use NaiveDiceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Doorman.Login.Session
  end

  pipeline :authentication do
    plug NaiveDiceWeb.Plugs.RequireLogin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", NaiveDiceWeb do
    pipe_through :browser

    get "/login", SessionController, :new
    resources "sessions", SessionController, only: [:create]
    resources "users", UserController, only: [:new, :create]
  end

  scope "/", NaiveDiceWeb do
    pipe_through [:browser, :authentication]
  
    get "/", EventController, :index
    resources "events", EventController, only: [:index, :show]
    resources "tickets", TicketController, only: [:create]
    resources "stripe_payments", StripePaymentController, only: [:create]
  end
end
