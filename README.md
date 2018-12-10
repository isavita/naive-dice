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
  * Tickets - It belongs to `user`, `event`, and `ticket_schema` (it was planned to allow use of multiple ticket schemas for the same event).
      It has unique index between `user_id` and `event_id` to not allow creation of more than one ticket for the event. This
      is to match the task requirement and guarantee that user didn't get two tickets for the same event.
  * Checkouts - It has basic fields returned by Stripe `email`, `token`, and `token_type`, also it belongs to `user`.
      It is created in transaction for charging via the Stripe API to make sure that is created only if the last was successful.
  * Charge infos - It belongs to `checkout` and has information for `outcome`, `source`, and the `charge` itself.
      At the moment all three are serialized `JSONB`s. It is used for tracking outcome of charges.
  * User - It is used only for login and to put limits how many profiles can you create.

## Edge case scenarios

  * We are sending the same request twice (Network problems) - The `charge` call includes in the header `idempotency key` (base on ticket id).
      This guarantee that if we repeat a request, the last will be rejected and we want charge the user's card twice.
  * User is trying to create more than one ticket for the same event (Misbehaving users) - At the moment there is constraint
      on database that make sure that the same user cannot have more than one ticket for event.
  * User is trying to pay ticket with someone's else card (Hack Attempts) - At the moment there is check in `StripePaymentController`
      that the ticket belongs to the current_user and also is not paid already.
  * Stripe outage - We do not create Checkout or update the ticket to paid due to the fact that everything is wrapped in transaction
      if the call to Stripe API for `charge` failes we do not create `checkout` and we do not update `ticket` to paid.
      
