# Configuration

Square issues a distinct OAuth access token per merchant, so you supply a resolver that returns a
fresh token for a given `Pay::Customer`:

```ruby
# config/initializers/pay.rb

# Return a fresh per-merchant Square OAuth access token. force_refresh is true on the
# retry after a 401 — bypass any cache and refresh.
Pay::Square.access_token_provider = ->(pay_customer, force_refresh = false) do
  account = ConnectedAccount.find_by!(owner: pay_customer.owner, provider: "square")
  account.refresh! if force_refresh
  account.access_token
end
```

Credentials (resolved via `ENV`, then env-scoped, then unscoped Rails credentials):

* `SQUARE_ENVIRONMENT` — `sandbox` or `production` (default `production`)
* `SQUARE_SIGNING_SECRET` — webhook signature key
* `SQUARE_WEBHOOK_NOTIFICATION_URL` — the exact URL registered with Square (its HMAC covers `notification_url + body`)
