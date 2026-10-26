# Installation

Add Pay, this gem, and the Square SDK to your Gemfile. The default is patch releases only, with the
compatible Pay and Square lines inline:

```ruby
# Gemfile
gem "pay", ">= 11.0", "< 13" # Pay 11.x or 12.x
gem "pay-square", "~> 0.1.0" # patch releases of the 0.1 line
gem "square.rb", "~> 44"     # the Square SDK — your app provides it
```

`pay-square` does not depend on `square.rb` directly; like Pay's built-in processors, it expects your
app to provide the SDK gem. If `square.rb` is absent, the processor simply stays disabled.

## Living on the edge (pre-releases)

Release candidates ship as pre-releases (e.g. `0.1.0.rc1`). To follow the newest pre-release of the
`0.1` line automatically — without pinning to a specific one — add `.pre` to the constraint:

```ruby
gem "pay-square", "~> 0.1.0.pre" # newest 0.1.x, pre-releases included
```

A plain `~> 0.1.0` never installs a pre-release; this opts in and still stays on the `0.1` line.
`bundle update pay-square` then moves you to the newest version it allows. See
[UPGRADE.md](../UPGRADE.md) for how versions are managed.

## Migration

Copy and run the migration that adds `square_account` to Pay's tables:

```sh
bin/rails pay_square:install:migrations
bin/rails db:migrate
```
