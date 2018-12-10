# NaiveDice

## Setup
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup` (this includes `seeds` with two events)
  * Install Node.js dependencies with `cd assets && npm install`
  * Add ENV variable `STRIPE_API_PUBLISHABLE_KEY` and `STRIPE_API_SECRET_KEY` OR change `config/dev.exs` to use `NaiveDice.StripeApi.InMemory`
    instead of `NaiveDice.StripeApi.HTTPClient`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To run the tests:

  * Run `mix test`


## Database schema consists from 6 tables

  * Events - It has basic information for the event and has `starts_at` and `ends_at`,
      also has unique index between `title` and `starts_at` to make sure there is no overlapping events with the same name.
  * Ticket schemas - It plays the role of ticket template, also keep track of how many tickets are available.
      It belongs to an event, it has basic information for `amount_pennies` and `currency`, also `available_tickets_count`.
      It has `lock_version` to avoid issues with concurrent decrement of the same `available_tickets_count` from two different users.
  * Ticket - It belongs to `user`, `event`, and `ticket_schema` (it was planned to allow use of multiple ticket schemas for the same event).
      It has unique index between `user_id` and `event_id` to not allow creation of more than one ticket for the event. This
      is to match the task requirement and guarantee that user didn't get two tickets for the same event.
  * Checkout - It has basic fields returned by Stripe `email`, `token`, and `token_type`, also it belongs to `user`.
      It is created in transaction for charging via the Stripe API to make sure that is created only if the last was successful.
  * ChargeInfo - It belongs to `checkout` and has information for `outcome`, `source`, and the `charge` itself.
      At the moment all three are serialized JSONB. It is used for tracking outcome of charges.
  * User - It is used only for login and to put limits how many profiles can you create.
