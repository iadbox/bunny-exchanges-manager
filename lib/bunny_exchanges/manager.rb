require 'bunny'

module BunnyExchanges
  # The required exchange is not defined.
  UndefinedExchange = Class.new(StandardError)

  # Class keeps all configured exchanges through the same connection and channel.
  class Manager
    # Constructor.
    #
    # @param [BunnyExchanges::Configuration] the exchanges configuration.
    def initialize config = BunnyExchanges.configuration
      @config    = config
      @exchanges = Hash.new { |exchanges, service| exchanges[service] = Hash.new }
    end

    # Gets or builds the required exchange.
    #
    # @param [Symbol] the service name.
    # @param [Symbol] the action name.
    # @return [Bunny::Exchange] the required bunny exchange.
    # @raise [BunnyExchanges::Manager::UndefinedExchange] when the exchange is not defined.
    def get service, action
      exchanges[service.to_sym][action.to_sym] ||= begin
        name, options = params_for(service, action)

        channel.exchange(name, options)
      end
    end

  private

    attr_reader :exchanges, :config

    def params_for service, action
      options = options_for(service, action)
      name    = options.delete(:name)

      [name, options]
    end

    def options_for service, action
      config_for(service, action).reduce({}) do |hash, (option, value)|
        hash.merge! option.to_sym => value
      end
    end

    def config_for service, action
      config.exchanges.
        fetch(service.to_s) { raise_undefined(service, action) }.
        fetch(action.to_s)  { raise_undefined(service, action) }
    end

    def channel
      @channel ||= begin
        conn = Bunny.new(config.rabbitmq)
        conn.start

        conn.create_channel
      end
    end

    def raise_undefined service, action
      raise BunnyExchanges::UndefinedExchange,
        "No exchange is defined for service #{service} and action #{action}"
    end
  end
end
