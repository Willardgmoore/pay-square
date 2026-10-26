# AGENTS.md

Guidance for AI coding agents working in this repository. Keep changes small, match the surrounding
code, and leave the tree reading the way the existing code reads.

## Comments

**The best comment is no comment.** Code should explain itself through clear names and small, focused
methods and objects. Comments drift out of sync with the code quickly, and a stale comment is worse
than none — so treat every comment as a future liability.

Before writing one, seriously weigh whether it is needed; most are not. When a comment genuinely earns
its place, it is only to capture a **why** the code cannot express on its own: a non-obvious decision,
a workaround, or an external constraint (an API quirk, an ordering requirement, a deliberate omission a
reader might otherwise "fix"). Keep it short.

- Never restate what the code already says.
- If you're tempted to comment *what* a block does, extract a named method instead.
- Delete comments that no longer match the code you're touching.

## Tests

- Run the suite: `bundle exec rake test`.
- The suite boots a dummy Rails app under `test/dummy`. Keep it green across the Pay versions the
  gemspec allows (CI runs the matrix).
- Add or update tests with any behavior change; prefer a test that fails without the change.
- Lint with `bundle exec standardrb`.

## Conventions

- This is a Pay payment processor shipped as its own gem. Mirror Pay's built-in processors:
  `Pay::Square::Customer` / `Charge` / `PaymentMethod`, the webhook handlers, and the engine.
- `square.rb` is an **app-provided** dependency. Do not add it to the gemspec or `require "square"` at
  load time; the processor gates on `defined?(::Square)`.
- Supported `pay` and `square.rb` ranges live in the gemspec. Only widen a range you have tested.
- Keep the README short; put detail in `docs/`.

## Releasing

Releases are tag-driven (`v*`) through trusted publishing — see `UPGRADE.md`. Never publish on a
push to `main`, and never move or delete a published tag.
