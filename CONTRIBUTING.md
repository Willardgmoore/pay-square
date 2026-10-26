# Contributing to pay-square

Thanks for your interest — contributions are welcome, whether that's a bug report, a
documentation fix, or a pull request. This is a small, focused gem (a Square payment
processor for [Pay](https://github.com/pay-rails/pay)), so a quick issue before a large
change saves everyone time.

## Reporting bugs and requesting features

[Open an issue](https://github.com/Willardgmoore/pay-square/issues). A good report includes:

- What you did, what you expected, and what actually happened.
- The versions involved: `pay-square`, `pay`, `square.rb`, Ruby, and Rails.
- A stack trace or the relevant log lines, and a minimal way to reproduce it if you have one.

For a feature or behavior change, open an issue describing the use case first so we can
agree on the shape before you write code.

## Development setup

```sh
git clone https://github.com/Willardgmoore/pay-square.git
cd pay-square
bundle install
bundle exec rake test   # runs the suite against the dummy Rails app
```

The tests mock the Square API (WebMock + Mocha), so no Square account or network access is
needed. The suite is expected to pass against every Pay version the gemspec allows.

## Making a change

1. Fork the repo and create a branch off `main`.
2. Make your change, and **add or update tests** — the suite must stay green. Where a change
   guards a specific behavior, prefer a test that fails without the change (see the Pay 12
   behavior tests for examples).
3. Run the linter: `bundle exec standardrb` (this project uses [standard](https://github.com/standardrb/standard)).
4. Add a bullet to the `## Unreleased` section of `CHANGELOG.md` describing the change.
5. Open a pull request against `main`. Describe the problem and the fix, and link any related
   issue. Keep the diff focused — unrelated cleanups belong in their own pull request.

## Compatibility

`pay-square` adapts Square to Pay, so changes should respect both contracts:

- Supported `pay` and `square.rb` ranges are declared in `pay-square.gemspec`. Only widen a
  range you have actually tested, and note the verified versions in the CHANGELOG.
- The Square SDK is provided by the host app, not depended on directly (the processor gates on
  `defined?(::Square)`). Keep that convention; see the README and gemspec comments.

## Releasing

Cutting releases and managing tags is a maintainer task with a few one-way-door rules (a pushed
tag is immutable, pre-releases for anything unverified, etc.). See [UPGRADE.md](UPGRADE.md).

## Code of conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md). Be respectful and
constructive, assume good faith, and help keep this a welcoming place to contribute.
