# frozen_string_literal: true

module RateLimiter
  class VersionTest < ActiveSupport::TestCase
    # See https://github.com/semver/semver/pull/460
    SEMVER_REGEX = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/.freeze

    it 'returns a SemVer string' do
      assert(::RateLimiter::VERSION.match(SEMVER_REGEX))
    end
  end
end
