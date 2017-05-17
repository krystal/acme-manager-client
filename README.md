# AcmeManager

This is a client library for [acme-manager](https://github.com/catphish/acme-manager), which is a tool to issue and manage letsencrypt certificates on a host.

The library enables you to view the certificates currently managed by an instance of acme-manager, issue new certificates and provides an optional middleware to redirect letsencrypt domain verification requests to acme-manager.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acme_manager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acme_manager

## Configuration

To configure the library you must configure the location of your acme-manager server and provide it's API key. You can do this with a configure block, or with the environment variables `ACME_MANAGER_HOST` and `ACME_MANAGER_API_KEY`.

```ruby
# config/initializers/acme_manager.rb
AcmeManager.configure do |config|
  config.host = 'https://acme-manager.example.com'
  config.api_key = '1234567890'
end
```

## Usage

### Issuing a Certificate

To issue a certificate call `AcmeManager.issue` this will return an object which indicates whether the request was successful, and what errors were received if it wasn't.

```ruby
issue_request = AcmeManager.issue('subdomain.example.com')
issue_request.success?
# => false
issue_request.error
# => "Error message raised by LE"
```

### Listing Certificates

To get a list of existing certificates managed me acme-manager call `AcmeManager.list`. This will return an array of
certificate objects.

```ruby
certificate = AcmeManager.list.first
certificate.name
# => "subdomain.example.com"
certificate.not_after
# => 2017-05-17 16:18:22 UTC
certificate.expired?
# => false
```

### Verification Request Proxying

Acme-manager was designed to be run behind a load balancer, with any LetsEncrypt verification requests or requests to
/~acmemanager being sent to it.

If you're not lucky enough to have a load balancer that can siphon these requests for you, this library packs a
middleware that you can use to proxy the verification requests. Instructions below are for Rails, if you need to
include the middleware in another Rack app, you probably know what you're doing already.

```ruby
# config/application.rb
# ...
require 'acme_manager/middleware/forward_verification_challenge'

module MyApp
  class Application < Rails::Application
    # ...
    config.middleware.insert_before ActionDispatch::Static, AcmeManager::Middleware::ForwardVerificationChallenge
    # ...
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/acme_manager.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

