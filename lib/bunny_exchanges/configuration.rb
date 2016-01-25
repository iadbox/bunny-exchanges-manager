require 'yaml'

module BunnyExchanges
  # It stores the exchanges configuration.
  class Configuration
    DEFAULT_EXCHANGES_PATH = "config/exchanges.yml"
    DEFAULT_RABBITMQ_PATH  = "config/rabbitmq.yml"

    # Sets the path of the exchanges configuration file.
    #
    # @param [String] a path.
    attr_writer :exchanges_path

    # Sets the path of the rabbitmq configuration file.
    #
    # @param [String] a path.
    attr_writer :rabbitmq_path

    # Sets the ENV. If it is set, the rabbitmq configuration
    # for that env is taken, otherwise it gets the rabbitmq config file
    # contents directly.
    #
    # @param [String] the env.
    attr_writer :env

    # Constructor.
    def initialize
      @exchanges_path = DEFAULT_EXCHANGES_PATH
      @rabbitmq_path  = DEFAULT_RABBITMQ_PATH
    end

    # Loads the configuration YAML file contents.
    #
    # @return [Hash] the exchanges configuration.
    def exchanges
      @exchanges ||= YAML.load_file(exchanges_path)
    end

    # Loads the configuration YAML file contents for the environment if given.
    #
    # @return [Hash] the rabbitmq configuration.
    def rabbitmq
      @rabbitmq ||= if env
                      rabbitmq_contents.fetch(env)
                    else
                      rabbitmq_contents
                    end
    end

  private

    def rabbitmq_contents
      YAML.load_file(rabbitmq_path)
    end

    attr_reader :env, :exchanges_path, :rabbitmq_path
  end
end
