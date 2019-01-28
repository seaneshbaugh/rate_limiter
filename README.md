# Rate Limiter

Limit the rate at which ActiveRecord model instances can be created.

## Rails Version

This gem is compatible with Rails 5 or greater. For Rails 3 and 4 use [version 0.0.6](https://rubygems.org/gems/rate_limiter/versions/0.0.6).

## Installation

Add the gem to your project's Gemfile:

    gem 'rate_limiter'

## Basic Usage

In the models you want to rate limit simply call the `rate_limit` class method inside the model.

```ruby
class ProductReview < ApplicationRecord
  rate_limit
end
```

By default this will rate limit creation of instances using the `ip_address` attribute with an interval of one minute. This is a pretty big assumption that may change in future versions. To use a different attribute do the following:

```ruby
class ProductReview < ApplicationRecord
  rate_limit on: :username
end
```

This will instead check for `ProductReview`s with a matching `username` instead.

Because you may want to increase or decrease the interval between creating instances of your model you can do this:

```ruby
class ProductReview < ActiveRecord::Base
  rate_limit interval: 3.hours
end
```

## Contributing

If you feel like you can add something useful to rate_limiter then don't hesitate to contribute! To make sure your fix/feature has a high chance of being included, please do the following:

1. Fork the repo.

2. Run the tests. I will only take pull requests with passing tests, and it's great to know that you have a clean slate: `bundle && rake`

3. Add a test for your change. Only adding tests for existing code, refactoring, and documentation changes require no new tests. If you are adding functionality or fixing a bug, you need a test!

4. Make the test pass.

5. Push to your fork and submit a pull request.

I can't guarantee that I will accept the change, but if I don't I will be sure to let you know why!

Some things that will increase the chance that your pull request is accepted, taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation, guides, or whatever is affected by your contribution
