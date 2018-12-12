# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

new_year_eve = %DateTime{
  year: 2018,
  month: 12,
  day: 31,
  zone_abbr: "UTC",
  hour: 21,
  minute: 0,
  second: 0,
  microsecond: {0, 0},
  utc_offset: 0,
  std_offset: 0,
  time_zone: "Etc/UTC"
}

event =
  NaiveDice.Repo.insert!(%NaiveDice.Bookings.Event{
    title: "Alexandra Palace: Bring Me The Horizon",
    description:
      "Sheffield emo legends Bring Me The Horizon are your headliner. Don't miss this.",
    image_url: "/images/bring-me-the-horizon.jpg",
    starts_at: new_year_eve
  })

NaiveDice.Repo.insert!(%NaiveDice.Bookings.TicketSchema{
  event_id: event.id,
  amount_pennies: 1000,
  currency: "gbp",
  available_tickets_count: 5
})

event =
  NaiveDice.Repo.insert!(%NaiveDice.Bookings.Event{
    title: "Camden Assembly: Radiohead",
    description:
      "Radiohead’s UK tour seems designed to prove a few self-evident truths. Don't miss your mad uncles.",
    image_url: "/images/radiohead.jpg",
    starts_at: new_year_eve
  })

NaiveDice.Repo.insert!(%NaiveDice.Bookings.TicketSchema{
  event_id: event.id,
  amount_pennies: 12000,
  currency: "gbp",
  available_tickets_count: 5
})
