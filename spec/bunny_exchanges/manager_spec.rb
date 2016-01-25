require 'bunny_exchanges/manager'

RSpec.describe BunnyExchanges::Manager do

  let :exchanges_config do
    {
      "service_1" => {
        "action_1" => {
          "name" => "an.exchange.name",
          "type" => "fanout",
          "durable" => false,
          "auto_delete" => true,
          "arguments" => {
            "one" => 1,
            "two" => "second"
          }
        },
        "action_2" => {
          "name" => "the.name"
        },
      },
      "service_2" => {
        "action_1" => {
          "name" => "another",
          "type" => "topic"
        }
      }
    }
  end

  let :config do
    double 'config', :exchanges => exchanges_config,
                     :rabbitmq  => {}
  end

  subject { described_class.new config }

  describe '#get' do
    context 'with a defined exchange' do
      it 'builds and caches the exchange' do
        exchange = subject.get(:service_1, :action_1)

        expect(exchange).to be_a Bunny::Exchange

        expect(exchange.name        ).to eq "an.exchange.name"
        expect(exchange.type        ).to eq "fanout"
        expect(exchange.durable?    ).to eq false
        expect(exchange.auto_delete?).to eq true
        expect(exchange.arguments   ).to eq "one" => 1, "two" => "second"

        exchange_again = subject.get(:service_1, :action_1)
        expect(exchange.object_id).to eq exchange_again.object_id
      end
    end

    context 'with an undefined exchange' do
      it 'raises error' do
        expect{ subject.get(:service_3, :action_1) }.
          to raise_error BunnyExchanges::UndefinedExchange
      end
    end
  end

end
