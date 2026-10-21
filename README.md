# Pay::Square

A [Square](https://squareup.com/) payment processor for the [Pay](https://github.com/pay-rails/pay) gem.

Unlike Stripe Connect (one platform key + a `stripe_account` header), Square issues a
**distinct OAuth access token per merchant**. So this processor charges on a merchant's
**own connected Square account** (you are not the merchant of record) and builds a
`Square::Client` per operation from a token you supply via a resolver.

Scope: card payments, card-on-file, refunds, and payment/refund/card/customer webhooks.
Square OAuth, token refresh, payouts/reconciliation, catalog, and the checkout UI stay in
your app.

## Requirements

- Ruby >= 3.1.0
- [Pay](https://github.com/pay-rails/pay) 11.x or 12.x (verified against 11.7.2 and 12.3.0)
- [square.rb](https://github.com/square/square-ruby-sdk) ~> 44

## Installation

```ruby
# Gemfile
gem "pay"
gem "pay-square"
gem "square.rb", "~> 44" # the Square SDK — your app declares it, as Pay expects for stripe/braintree
```

`pay-square` does not depend on `square.rb` directly; like Pay's built-in processors, it expects
the host app to provide the SDK gem. If `square.rb` is absent the processor simply stays disabled.

Then copy and run the migration that adds `square_account` to Pay's tables:

```sh
bin/rails pay_square:install:migrations
bin/rails db:migrate
```

## Configuration

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

## Usage

```ruby
# Scope the customer to a merchant
@user.set_payment_processor :square, square_account: "MLXXXXXXXXXXXX"

# Card on file (source_id is a nonce from Square's Web Payments SDK)
@user.payment_processor.add_payment_method("cnon:...", default: true)

# Charge (integer minor units), optional application fee + idempotency key
charge = @user.payment_processor.charge(10_00, application_fee_amount: 1_00, idempotency_key: "order-42")
charge.processor_id     # Square payment id
charge.square_order_id

# Refund (async; amount_refunded syncs from Square)
charge.refund!(5_00)
```

Because `square_account` is part of the customer lookup key, one user transacting with two
different Square merchants gets two isolated `Pay::Customer` records.

Square has no server-side SCA step (3-D Secure is client-side in the Web Payments SDK), so
`Pay::Payment` / `has_incomplete_payment?` do not apply — a charge either succeeds or raises
`Pay::Square::Error`.

## Webhooks

Point your Square webhook subscription at `/pay/webhooks/square`. Requests are verified
against `SQUARE_SIGNING_SECRET`. Handled events: `payment.*`, `refund.*`, `card.*`,
`customer.*`. Handlers re-fetch authoritative state from the API rather than trusting the
payload, so out-of-order/duplicate deliveries are safe.

## License

MIT.
