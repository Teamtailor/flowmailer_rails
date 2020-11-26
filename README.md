# FlowmailerRails
[![Gem Version](https://badge.fury.io/rb/flowmailer_rails.svg)](https://rubygems.org/gems/flowmailer_rails)
![Tests](https://github.com/teamtailor/flowmailer_rails/workflows/Ruby/badge.svg)

Send ActionMailer emails with Flowmailer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flowmailer_rails'
```

And then execute:

    $ bundle

## Usage

### Configuration

Add basic configuration by providing it with your account id and client Id and Secret for an API source with submitt access.
```ruby
# config/production.rb
config.action_mailer.flowmailer_settings = {
  account_id: ENV["FLOWMAILER_ACCOUNT_ID"],
  client_id: ENV["FLOWMAILER_CLIENT_ID"],
  client_secret: ENV["FLOWMAILER_CLIENT_SECRET"],
}
```

You can also provide procs that handles the `access_token` retrieval if you already have that logic in your Rails app:
```ruby
# config/production.rb
config.action_mailer.flowmailer_settings = {
  account_id: ENV["FLOWMAILER_ACCOUNT_ID"],
  access_token: -> { FooBar.access_token },
  fetch_new_access_token: -> { FooBar.fetch_new_access_token },
}
```

Tell Rails to use Flowmailer as the delivery method

```ruby
# config/production.rb
config.action_mailer.delivery_method = :flowmailer
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/teamtailor/flowmailer_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FlowmailerRails project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/teamtailor/flowmailer_rails/blob/master/CODE_OF_CONDUCT.md).
