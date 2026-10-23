# Changelog

## Unreleased

* Adopted Pay's `.github` conventions: a `Standardrb` lint job in CI, a reusable `ci.yml`
  (`workflow_call`) that the publish workflow runs before releasing, per-job timeouts, and
  `actions/checkout@v6`. Renamed `release.yml` to `publish_gem.yml`.
* Added `.standard.yml` (ignoring the generated dummy app), `dependabot.yml` (bundler + GitHub
  Actions, monthly), a pull request template, and bug/feature issue templates.

* Added CI (`.github/workflows/ci.yml`): runs the test suite on every pull request and push to
  `main`, across Ruby 3.1–3.4 and Pay 11 + 12, behind a single `All tests passed` check.
* The release workflow now runs the tests first and only publishes to RubyGems if they pass.
* `Gemfile` honors `PAY_VERSION` so CI can pin the Pay major under test.

* Added trusted-publishing release workflow (`.github/workflows/release.yml`): a `v*` tag push
  publishes to RubyGems via OpenID Connect, no stored API key. See `RELEASING.md`.
* Removed the generated `gem-push.yml` starter workflow in favor of `release.yml` (it published on
  every push to main, pinned Ruby 2.6, and also pushed to GitHub Packages).
* README: added gem version / Ruby / license badges and a Links section; vendored the RubyGems
  logos under `assets/rubygems/`.
* README reorganized to follow Pay's conventions: Pay logo + tagline, badges on one line, a blockquote
  for the upstream endorsement, and a `📚 Docs` section linking to dedicated pages under `docs/`
  (installation, configuration, usage, webhooks).
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
