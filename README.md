# BunnyExchangesManager

This gem provides a way to create and keep RabbitMQ exchanges using Bunny,
and keep them to be used.

## Installation

Add this line to your application's Gemfile:

    gem 'bunny_exchanges_manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bunny_exchanges_manager

## Usage

To use `BunnyExchanges` you must define the configuration of each exchange in the
YAML config file.

By default the path to the configuration file is `config/exchanges.yml`, but you
can provide a specific path with:
```ruby
BunnyExchanges.configure do |config|
  config.exchanges_path = "my/custom/path"
end
```

### The configuration file

In the configuration file you have to name and define all your exchanges:
```yml
an_action:
  name: the.exchange.name
  type: fanout
  durable: false
  auto_delete: true
  arguments:
    one_argument: 1
    another_argument: "2"

another_action:
  name: another.exchange.name
  type: topic
```

### Get exchanges

To get a configured exchange:
```ruby
BunnyExchanges.get(:an_action) # => #<Bunny::Exchange:...>
```

### Connections

The default connection config file path is `config/rabbitmq.yml`, although you
can provide as much connections as needed with:
```ruby
BunnyExchanges.configure do |config|
  config.connections = { 
    :default => "config/rabbitmq/default.yml",
    :another => "config/rabbitmq/another.yml",
  }
end
```

The connection file needs to have the same parameters `Bunny.new` can accept,
for example:

```yml
:host: localhost
:port: 5672
:user: guest
:pass: guest
:vhost: /
:threaded: true
:heartbeat: 2
```

Or it can also have a connection definition for each environment of your app:

```yml
development:
  :host: localhost
  :port: 5672
  :user: guest
  :pass: guest
  :vhost: /
  :threaded: true
  :heartbeat: 2

test:
  :host: localhost
  :port: 5672
  :user: guest
  :pass: guest
  :vhost: /
  :threaded: true
  :heartbeat: 2
```

In case you want to use this feature, you must provide the environment in an initializer:

```ruby
BunnyExchanges.configure do |config|
  config.env = Rails.env
end
```

### Pre-forking servers

There are situations when you need to reconnect to your AMQP server.
A common case is when you use BunnyExchanges with pre-forking servers like
PhussionPassenger or Unicorn.
For those situations a `BunnyExchanges.reset!` method is provided.

The following example shows how to reset your connection after a fork on
PhussionPassenger.
```ruby
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    BunnyExchanges.reset! if forked
  end
end

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bunny_exchanges_manager/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
