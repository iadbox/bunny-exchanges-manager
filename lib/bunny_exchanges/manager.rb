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
      @exchanges = {}
      @channels  = {}
    end

    # Gets or builds the required exchange.
    #
    # @param [Symbol, Symbol] the action name and the connection name
    # @return [Bunny::Exchange] the required bunny exchange.
    # @raise [BunnyExchanges::Manager::UndefinedExchange] when the exchange is not defined.
    def get action, connection_name
      exchanges[action.to_sym] ||= begin
        name, options = params_for(action)

        channel_for(connection_name).exchange(name, options)
      end
    end

  private

    attr_reader :exchanges, :config

    def params_for action
      options = options_for(action)
      name    = options.delete(:name)

      [name, options]
    end

    def options_for action
      config_for(action).reduce({}) do |hash, (option, value)|
        hash.merge! option.to_sym => value
      end
    end

    def config_for action
      config.exchanges.fetch(action.to_s) { raise_undefined(action) }
    end

    def channel_for connection_name
      @channels[connection_name] ||= begin
        conn = Bunny.new(config.connection_config(connection_name))
        conn.start

        conn.create_channel
      end
    end

    def raise_undefined action
      raise BunnyExchanges::UndefinedExchange,
        "No exchange is defined for action #{action}."
    end
  end
end
