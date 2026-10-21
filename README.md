<p align="center">
  <a href="https://github.com/pay-rails/pay"><img src="https://raw.githubusercontent.com/pay-rails/pay/main/docs/images/logo.svg" height="50px" alt="Pay"></a>
</p>

# 💳 Pay::Square — Square for the Pay gem

[![Gem Version](https://img.shields.io/gem/v/pay-square?logo=rubygems&logoColor=white)](https://rubygems.org/gems/pay-square) [![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.1-CC342D?logo=ruby&logoColor=white)](pay-square.gemspec) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](MIT-LICENSE)

A **[Square](https://squareup.com/)** payment processor for **[Pay — the payments engine for Ruby on Rails](https://github.com/pay-rails/pay)**.

## 🏦 A Pay processor, shipped as its own gem

[Pay](https://github.com/pay-rails/pay) already speaks Stripe, Braintree, Paddle, and Lemon Squeezy.
`pay-square` extends it with **Square** — registered from the outside, as its own gem, with no fork of
Pay. The whole point is to grow what Pay can do without bloating its core.

This follows a convention Pay's maintainer, Chris Oliver, endorsed when Square was first proposed for
Pay core:

> You're welcome to extract this to a Rubygem that integrates with Pay. 👍
>
> — [Chris Oliver, pay-rails/pay#1251](https://github.com/pay-rails/pay/pull/1251)

Braintree and Paddle are slated to move to their own gems too. It's the same outside-plugin pattern as
[`pay-asaas`](https://github.com/PedroAugustoRamalhoDuarte/pay-asaas): a Rails engine that
self-registers its processor, webhooks, and models into Pay.

### What's Square-specific

Unlike Stripe Connect (one platform key + a `stripe_account` header), Square issues a **distinct OAuth
access token per merchant**. So this processor charges on a merchant's **own connected Square account**
(you are not the merchant of record) and builds a `Square::Client` per operation from a token you
supply via a resolver.

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
- [Versioning & releasing](RELEASING.md) — SemVer, tags, pre-releases, and publishing
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
