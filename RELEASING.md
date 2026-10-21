# Releasing pay-square

How we version, tag, and release this gem. Read this before cutting a release or
creating a tag. It exists because tags are the contract the downstream app (and
anyone else) pins to, and a few of the rules below are one-way doors.

## Versioning: Semantic Versioning

We follow [Semantic Versioning 2.0.0 (SemVer)](https://semver.org). The version
lives in exactly one place, `lib/pay/square/version.rb` (`Pay::Square::VERSION`),
and is `MAJOR.MINOR.PATCH`:

- **MAJOR** — a backward-incompatible change to the gem's public API, or a hard
  change in what it supports (dropping Pay 11, requiring a new `square.rb` major).
- **MINOR** — backward-compatible new behavior.
- **PATCH** — backward-compatible bug fixes only.

**While we are below 1.0 (the `0.x` line):** the public API is still stabilizing.
SemVer item 4 says "anything MAY change at any time" at major-version zero. Our
convention for `0.x`: a breaking change bumps the **MINOR** (`0.1.0` → `0.2.0`),
a fix bumps the **PATCH** (`0.1.0` → `0.1.1`). We cut `1.0.0` once the public API
is stable and a real consumer runs on it in production.

## What a tag means here

- A tag marks a **release**: a specific commit we intend a consumer to depend on.
  We tag every version we publish (or intend to publish), and we do **not** tag
  arbitrary work-in-progress commits.
- Tags are **annotated** (`git tag -a`), so they carry a message, author, and
  date. Sign them (`git tag -s`) once we have a signing key.
- The tag name is the version with a `v` prefix: `v0.1.0`. It must match
  `Pay::Square::VERSION` and the matching `## 0.1.0` heading in `CHANGELOG.md`.
  Those three always move together.
- Use the tag message to record what the release is compatible with and any
  breaking changes (for example "compatible with Pay 11.x/12.x; square.rb ~> 44").
  That is documentation for humans. The compatibility a machine actually enforces
  lives in the gemspec constraints (`spec.add_dependency "pay", ">= 11.0", "< 13"`),
  not in the tag.

## The one hard rule: a published tag is immutable

Once a tag is pushed to the remote (or a version is published to RubyGems), it is
**frozen**. Never move it, never delete-and-recreate it on a different commit,
never force-push it.

- SemVer: "the contents of that version MUST NOT be modified. Any modifications
  MUST be released as a new version."
- RubyGems: a version number on RubyGems.org can **never** be reused, even after a
  yank.
- Downstream tools and caches pin to the tag/commit; moving a published tag
  silently changes what everyone has already resolved.

If a release is broken, **fix forward**: commit the fix, bump the version (usually
PATCH), cut a new tag. Never patch the old tag.

**The only exception — local, unpushed tags.** A tag that exists only on your
machine and has not been pushed is not yet "published." You may move or delete it
freely while preparing a release. The moment you `git push` it, or publish the
gem, the immutability rule takes over. (This is why it was fine to move `v0.1.0`
while it sat local and unpushed, and why it stops being fine the instant we push.)

## Pre-releases: for anything not yet verified

When a release has not been exercised by a real consumer yet, cut a **pre-release**
instead of the final version. RubyGems treats any version containing a letter as a
pre-release: `0.1.0.rc1` (release candidate), `0.1.0.beta1`, `0.1.0.pre`. (The
SemVer spelling is `0.1.0-rc.1`; use the RubyGems dotted-letter form in
`version.rb` so `Gem::Version` and the release tooling recognize it as a
pre-release.)

Why it matters:

- `gem install pay-square` installs the newest **stable** version and ignores
  pre-releases; `gem install pay-square --pre` is needed to get one. In a Gemfile,
  Bundler picks a pre-release only when a requirement names it explicitly:
  `gem "pay-square", "0.1.0.rc1"`.
- So a pre-release lets the consuming app opt in and verify a candidate without it
  becoming the default that everyone else resolves to.

Flow: cut `v0.1.0.rc1` → the consumer pins and verifies it → if changes are needed,
cut `v0.1.0.rc2` (a **new** tag; `rc1` is never reused) → once verified, cut the
final `v0.1.0`. Pre-release tags are still immutable once pushed: you supersede
them with a higher pre-release or the final release, never by moving them.

Rule of thumb for this gem: **if the downstream app has not actually run against
the commit, release it as a `.rcN` pre-release, not a final version.**

## Compatibility and breaking changes

- **Compatibility is enforced by the gemspec, not by tags.**
  `spec.add_dependency "pay", ">= 11.0", "< 13"`,
  `spec.add_dependency "square.rb"` guidance, and `spec.required_ruby_version` are
  what actually gate installs. Keep them honest: only widen a floor or ceiling you
  have tested (see issue #1 for Pay and issue #2 for `square.rb`).
- **Document** compatibility and breaking changes in `CHANGELOG.md` and in the tag
  message, so a human can see them at a glance without reading the gemspec.
- **Deprecations:** announce in the CHANGELOG and keep the deprecated behavior for
  at least one MINOR release before removing it in a MAJOR (post-1.0), per the
  SemVer FAQ.

## Publishing to RubyGems (trusted publishing)

We publish through **trusted publishing**: RubyGems authenticates the release via
GitHub's OpenID Connect token, so there is **no API key or secret stored anywhere**.
The release runs in GitHub Actions (`.github/workflows/release.yml`), triggered by
pushing a version tag.

One-time setup on RubyGems.org (done by a gem owner, in the web UI — not something an
agent or CI can do):

1. Create / sign in to a RubyGems.org account and enable multi-factor authentication.
2. Register a trusted publisher for this gem. Because the gem is not published yet,
   add it as a **pending** trusted publisher from your profile's pending-publisher
   page, with: gem name `pay-square`, owner `Willardgmoore`, repository `pay-square`,
   workflow `release.yml`. The first successful push promotes it and makes you the
   gem's owner. (We do not set a GitHub environment; if you add one on RubyGems, also
   add `environment:` to the workflow job.)

After that, releasing is just pushing a tag (see the checklist). The gemspec sets
`metadata["rubygems_mfa_required"] = "true"`; trusted-publishing pushes satisfy that,
so CI keeps working without a stored key.

**Nothing publishes on a red build.** Two gates stand in front of RubyGems:

1. `ci.yml` runs the test suite on every pull request and push to `main` (Ruby 3.1–3.4,
   Pay 11 + 12). `main` is branch-protected so a PR cannot merge unless the single
   `All tests passed` check is green, and `main` runs CI again after the merge.
2. `release.yml` re-runs the tests on the tagged commit and publishes **only if they
   pass**. A tag never ships a red build.

So the path is: PR → CI green → merge to `main` → CI green on `main` → cut the tag from
that green commit → release workflow re-tests and publishes.

## Release checklist

1. Decide the bump: MAJOR / MINOR / PATCH, or a `.rcN` pre-release if the commit is
   not yet verified by the consuming app.
2. Update `lib/pay/square/version.rb`.
3. Update `CHANGELOG.md`: give the new version a dated heading and list
   compatibility and any breaking changes.
4. Run the suite green: `bundle exec rake test` (against the Pay versions the
   gemspec allows).
5. Commit and land the release commit on `main` first.
6. Release **from `main`** by pushing the annotated tag, which triggers the workflow:
   ```sh
   git checkout main && git pull
   git tag -a vX.Y.Z -m "…compatibility / notable changes…"
   git push origin vX.Y.Z
   ```
   The `release.yml` workflow then runs `bundle exec rake release` (via
   `rubygems/release-gem`) and publishes the `.gem` to RubyGems. Watch the Actions run;
   it awaits propagation and fails loudly if the push is rejected.

Landing on `main` before tagging avoids the dangling-tag trap: if the branch is
squash-merged, a tag left on the pre-merge branch commit points at a commit that never
reaches `main`. Publishing is not available until the trusted publisher above is
registered; until then, consumers can use the git source (see the README).
