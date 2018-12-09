use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :naive_dice, NaiveDiceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :naive_dice, NaiveDice.Repo,
  username: "postgres",
  password: "postgres",
  database: "naive_dice_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure stripe Adapter
config :naive_dice, :stripe_api, NaiveDice.StripeApi.InMemory
