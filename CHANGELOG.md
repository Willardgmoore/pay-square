# Changelog

## Unreleased

* Initial release: Square payment processor for Pay.
  * Charge on a merchant's own connected Square account (per-merchant OAuth) via a
    configurable `Pay::Square.access_token_provider`; a `Square::Client` is built per
    operation and retries once with a refreshed token on a 401.
  * Card-on-file (Cards API), charges (`CreatePayment`) with optional `app_fee_money`,
    and refunds.
  * Pay-mounted `/pay/webhooks/square` endpoint with HMAC signature verification; handlers
    re-fetch authoritative state (Square delivery is unordered).
  * Adds a `square_account` column to scope customers per merchant, with cross-merchant
    isolation in `set/add_payment_processor`.
