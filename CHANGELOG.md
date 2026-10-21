# Changelog

## 0.1.0 - 2026-10-21

* Compatible with Pay 11.x and 12.x (verified against Pay 11.7.2 and 12.3.0).
* Fixed test suite boot order so the dummy app's environment loads before the gem.
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
