<p align="center">
  <a href="https://github.com/pay-rails/pay"><img src="https://raw.githubusercontent.com/pay-rails/pay/main/docs/images/logo.svg" height="50px" alt="Pay"></a>
</p>

# 💳 Pay::Square — Square for the Pay gem

[![Gem Version](https://img.shields.io/gem/v/pay-square?logo=rubygems&logoColor=white)](https://rubygems.org/gems/pay-square) [![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.1-CC342D?logo=ruby&logoColor=white)](pay-square.gemspec) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](MIT-LICENSE)

A **[Square](https://squareup.com/)** payment processor for **[Pay — the payments engine for Ruby on Rails](https://github.com/pay-rails/pay)**.

## 🏦 Extending Pay — and why Square is its own gem

[Pay](https://github.com/pay-rails/pay) already speaks Stripe, Braintree, Paddle, and Lemon Squeezy.
`pay-square` adds **Square** from the outside — its own gem, no fork of Pay — the same self-registering
plugin pattern as [`pay-asaas`](https://github.com/PedroAugustoRamalhoDuarte/pay-asaas).

Pay's maintainer, Chris Oliver, both welcomed this and is taking the same direction for Pay's own
processors:

> I'm planning to extract Braintree and Paddle from the main gem. It doesn't bloat anything having them
> in the gem since they're lazy loaded, but easier to maintain. […] long-term we can add it to the pay
> org if you would like to keep maintaining it.
>
> — [Chris Oliver, pay-rails/pay#1251](https://github.com/pay-rails/pay/pull/1251#issuecomment-5545503069)

### Not just a processor — a marketplace integration

Braintree and Paddle are being split out for maintainability alone. Square is a different case: here it
is used for **[marketplace payments](https://github.com/pay-rails/pay/tree/main/docs/marketplaces)** —
Pay's term for charging on a connected merchant's **own account** and taking an **application fee** —
not merely to charge your own customers.

Square also issues a **distinct OAuth access token per merchant** (unlike Stripe Connect's single
platform key plus a `stripe_account` header). So `pay-square` charges on a merchant's **own connected
Square account** (the merchant, not you, is the merchant of record), building a `Square::Client` per
operation from a token you supply via `Pay::Square.access_token_provider`, and isolates customers per
merchant with a `square_account` column. That on-behalf-of, per-merchant model — not plain processing —
is a core reason Square belongs in its own gem.

Scope: card payments, card-on-file, refunds, and payment/refund/card/customer webhooks. Square OAuth,
token refresh, payouts/reconciliation, catalog, and the checkout UI stay in your app.

## 📋 Requirements

- Ruby >= 3.1.0
- [Pay](https://github.com/pay-rails/pay) 11.x or 12.x (verified against 11.7.2 and 12.3.0)
- [square.rb](https://github.com/square/square-ruby-sdk) ~> 44

## 📚 Docs

- [Installation](docs/installation.md) — Gemfile, pre-releases, and the migration
- [Configuration](docs/configuration.md) — the per-merchant token resolver and credentials
- [Usage](docs/usage.md) — charges, card-on-file, refunds, and per-merchant isolation
- [Webhooks](docs/webhooks.md) — endpoint, signature verification, and handled events
- [Versioning & releasing](UPGRADE.md) — SemVer, tags, pre-releases, and publishing
- [Contributing](CONTRIBUTING.md) — dev setup, running the tests, and opening issues

## 🙏 Contributing

Bug reports, feature ideas, and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) to
get started.

## 🔗 Links

[<img src="assets/rubygems/rubygems_logo_red.png" alt="RubyGems" height="24" align="left">](https://rubygems.org/gems/pay-square)

[pay-square on RubyGems](https://rubygems.org/gems/pay-square) · [Changelog](CHANGELOG.md)

The RubyGems and Pay logos are trademarks of their respective projects, used here to link to those
projects, not to imply endorsement.

## 📝 License

MIT.
