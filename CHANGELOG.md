# Changelog

## Unreleased

* Added trusted-publishing release workflow (`.github/workflows/release.yml`): a `v*` tag push
  publishes to RubyGems via OpenID Connect, no stored API key. See `RELEASING.md`.
* Removed the generated `gem-push.yml` starter workflow in favor of `release.yml` (it published on
  every push to main, pinned Ruby 2.6, and also pushed to GitHub Packages).
* gemspec now sets `rubygems_mfa_required`, and drops the duplicate `homepage_uri` metadata.

## 0.1.0.rc1 - 2026-10-21

First pre-release, cut for verification in a real consuming app before `0.1.0` is tagged
(see [RELEASING.md](RELEASING.md) for our pre-release policy).

* Compatible with Pay 11.x and 12.x (verified against Pay 11.7.2 and 12.3.0).
* The Square SDK (`square.rb`) is an app-provided dependency, matching Pay's convention for its
  built-in processors. Add `gem "square.rb", "~> 44"` to your app's Gemfile; `pay-square` no longer
  declares it and no longer `require`s it (the processor gates on `defined?(::Square)`).
* Added `RELEASING.md` (versioning and tag conventions) and `CONTRIBUTING.md`; documented release
  and pre-release pinning in the README.
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
