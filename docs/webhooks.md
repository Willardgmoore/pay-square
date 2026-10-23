# Webhooks

Point your Square webhook subscription at `/pay/webhooks/square`. Requests are verified against
`SQUARE_SIGNING_SECRET`. Handled events: `payment.*`, `refund.*`, `card.*`, `customer.*`.

Handlers re-fetch authoritative state from the API rather than trusting the payload, so
out-of-order and duplicate deliveries are safe.
