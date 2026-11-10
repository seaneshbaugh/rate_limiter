# Ruby 4 / Rails 8.1 release plan

Support Ruby 4.0 and Rails 8.1, with Ruby 4.0.9 and Rails 8.1.4.1 as
the initial verification targets. Older Ruby and Rails versions are outside
this release's support scope. Preserve existing rate-limiting functionality,
include correctness fixes, and defer broader redesign until compatibility is
established. Each numbered group is a proposed commit; split further if needed
to keep changes reviewable.

## 1. Update supported versions and dependencies

- [x] Set gem requirements to the supported Ruby 4.0 and Rails 8.1 series;
      keep exact patch targets in the development/test setup rather than
      forcing consumers to use those exact patches.
- [x] Update `.ruby-version`, `.tool-versions`, and the dummy app's Ruby
      version file consistently for Ruby 4.0.9.
- [x] Replace obsolete development dependency pins with compatible versions;
      review Rails, SQLite, Puma, Pry, Rake, RuboCop, SimpleCov, Timecop,
      and minitest-spec-rails. Remove dependencies the test app no longer needs.
- [x] Verify request_store compatibility with the target Rails/Rack stack.
- [x] Review the obsolete minimum RubyGems requirement and update or remove it.
- [x] Resolve dependencies and establish a reproducible local test command.

Section 1 verification: dependencies install and `bundle check` passes on Ruby
4.0.9 with Rails 8.1.4.1. An isolated Rails/SQLite smoke check verifies model
creation limiting, automatic request_store middleware installation, and cleanup
after successive requests and exceptions with Rack 3.2.8 / request_store 1.7.0.
The full suite currently stops while booting the old dummy app because
`sprockets/railtie` is unavailable; resolving that belongs to section 2.
Pry was removed as unused; Puma remains for running the dummy app manually.
Minitest stays on version 5 while the existing harness is modernized.

## 2. Modernize the Rails test application and test harness

- [ ] Move the dummy app to Rails 8.1 defaults and supported configuration,
      including exception handling and database setup.
- [ ] Reduce the app to frameworks and assets needed for model, controller,
      and generator tests; remove stale framework and Sprockets boot requirements
      where unnecessary.
- [ ] Update the Minitest integration, retaining the current test style if a
      supported adapter is available; otherwise use supported Minitest APIs.
- [ ] Replace deprecated `SimpleCov.add_filter` with `SimpleCov.skip`.
- [ ] Fix test files that rely on another test having loaded `test_helper`.
- [ ] Reset global/request configuration between tests and restore controller
      overrides even when assertions fail. Verify randomized test execution.
- [ ] Ensure the dummy controller performs one creation attempt per request
      rather than calling both `create` and `save`.
- [ ] Run the suite on Ruby 4.0.9 / Rails 8.1.4.1 and fix compatibility failures.

## 3. Make Rails loading and request lifecycle integration reliable

- [ ] Introduce a small Railtie with explicit Active Record and controller
      load hooks, removing integration that depends on constants already being
      defined at require time.
- [ ] Preserve the existing model DSL, controller hooks, and public
      configuration/request APIs.
- [ ] Verify controller integration for both standard and API-only Rails apps.
- [ ] Verify normal boot, eager loading, and development reloading without
      missing integration or duplicate callbacks/validations.
- [ ] Verify request_store middleware installation and cleanup across successive
      requests, including exceptions, so enablement and source do not leak.
- [ ] Cover thread isolation and document lifecycle expectations for callers
      outside HTTP requests. Retain request_store unless compatibility requires
      a replacement; defer a broader configuration/storage redesign.

## 4. Fix conditional options and temporary request configuration

- [ ] Make documented `if:` and `unless:` options actually control throttling.
      Preserve `if_condition:` / `unless_condition:` as compatibility aliases,
      with explicit precedence when both spellings are supplied.
- [ ] Add behavioral tests for true/false conditions and the record passed
      to each callable, rather than only checking stored options.
- [ ] Allow `RateLimiter.request { ... }` with no options.
- [ ] Ensure temporary request options restore previous state after normal
      completion, nested blocks, exceptions, and invalid options.
- [ ] Ensure the no-block path in `Request.with` does not clear existing state.
- [ ] Verify temporary configuration preserves the block's return value and
      restores source objects without unexpectedly changing their identity.
- [ ] Verify repeated `rate_limit` declarations and inherited model
      configuration do not produce duplicate validation errors or mutate
      another model's settings; fix any defects found.

## 5. Repair generated configuration and packaged installation

- [ ] Replace the nonexistent `config.timestamp_field` initializer example
      with working `config.rate_limit_defaults` examples for timestamp,
      interval, and limiting attributes.
- [ ] Include the locale template in the built gem and make generator source
      paths reliable from an installed gem.
- [ ] Test the generated initializer by loading it, and verify the generated
      locale produces the expected validation message.
- [ ] Build and install the gem into an isolated temporary location; run the
      generator against a Rails 8.1 app using the packaged files.

## 6. Complete behavioral regression coverage and query correctness checks

- [ ] Verify creation is blocked inside the interval and allowed afterward;
      explicitly cover the existing inclusive cutoff at exactly the interval.
- [ ] Preserve creation-only validation: updates to persisted records remain
      allowed, and rejected creates add the expected base error.
- [ ] Cover default/custom attributes, intervals, timestamp fields, global
      defaults, and model-level overrides.
- [ ] Preserve and test OR semantics for multiple limiting attributes:
      matching any configured attribute is sufficient to block creation.
- [ ] Cover global, request, model, and controller enable/disable controls,
      callable sources, and localized/fallback error messages.
- [ ] Use an existence query instead of loading matching records, with tests
      confirming equivalent limiting behavior.
- [ ] Document validation bypasses and the concurrent-insert race: this release
      does not introduce locking or guarantee atomic enforcement. Track strict
      concurrency enforcement as future work.

## 7. Replace Travis CI with GitHub Actions

- [ ] Remove `.travis.yml` and the Travis-specific Code Climate uploader.
- [ ] Add a GitHub Actions workflow for pushes and pull requests using Ruby
      4.0.9 and Rails 8.1.4.1, with Bundler caching and clean database setup.
- [ ] Run the complete test suite and gem build/package smoke checks in CI.
- [ ] Update RuboCop configuration for the selected version and target Ruby;
      keep lint changes focused and run lint in CI once it passes locally.
- [ ] Make CI independent of unavailable legacy coverage services/secrets;
      keep local coverage reporting and upload coverage as an artifact if useful.
- [ ] Replace obsolete Travis/coverage badges with accurate GitHub Actions
      status and supported coverage information.

## 8. Prepare release documentation and final verification

- [ ] Update README compatibility, setup, configuration, conditional options,
      multiple-attribute semantics, and contributor test instructions.
- [ ] Add changelog entries for dropped legacy support, compatibility updates,
      correctness fixes, packaging fixes, and GitHub Actions.
- [ ] Choose the release version and update `RateLimiter::VERSION`.
- [ ] From a clean dependency installation, verify tests, lint, gem build,
      packaged generator installation, and a model creation smoke test on
      Ruby 4.0.9 / Rails 8.1.4.1.
- [ ] Review packaged contents and confirm GitHub Actions passes before release.
- [ ] Publish/tag only when explicitly authorized; this plan does not publish
      the gem or change repository settings.

## Deferred improvements

- Broader configuration API redesign or replacement of the singleton/request
  storage architecture beyond changes required for correctness and compatibility.
- Atomic enforcement under concurrent inserts and associated database locking
  or schema requirements.
- Additional Ruby/Rails support matrices, new limiting strategies, and broader
  performance work.
