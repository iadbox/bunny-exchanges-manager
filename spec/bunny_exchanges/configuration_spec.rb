require 'bunny_exchanges/configuration'

RSpec.describe BunnyExchanges::Configuration do

  subject { described_class.new }

  describe '#exchanges_path= and #exchanges' do
    let :config_file do
      File.expand_path("../configuration/test_exchanges_configuration.yml" ,__FILE__)
    end

    let :expected_exchanges do
      {
        "action_1" => {
          "name" => "an.exchange.name",
          "type" => "fanout",
          "durable" => true,
          "auto_delete" => false,
          "arguments" => {
            "one" => 1,
            "two" => "second"
          }
        },
        "action_2" => {
          "name" => "the.name"
        },
        "action_3" => {
          "name" => "another",
          "type" => "topic"
        }
      }
    end

    it 'parses the exchanges config from a yaml file' do
      subject.exchanges_path = config_file

      expect(subject.exchanges).to eq expected_exchanges
    end
  end

  describe '#connections and #connection_config' do
    let :config_file do
      File.expand_path("../configuration/test_rabbitmq_configuration.yml" ,__FILE__)
    end

    context 'without environment' do
      let :expected_rabbitmq do
        {
          "development" => {"host" => "development_host"},
          "test"        => {"host" => "test_host"}
        }
      end

      it 'parses the rabbitmq config from a yaml file' do
        subject.connections = {default: config_file}

        expect(subject.connection_config(:default)).to eq expected_rabbitmq
      end
    end

    context 'with environment' do
      let(:expected_rabbitmq) { { "host" => "test_host" } }

      it 'parses the rabbitmq config from a yaml file' do
        subject.connections = {default: config_file}
        subject.env         = "test"

        expect(subject.connection_config(:default)).to eq expected_rabbitmq
      end
    end
  end

end
