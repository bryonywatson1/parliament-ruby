require_relative '../../spec_helper'

describe Parliament::Decorators::SeatIncumbency, vcr: true do
  let(:response) { Parliament::Request.new(base_url: 'http://localhost:3030').people('626b57f9-6ef0-475a-ae12-40a44aca7eff').get }

  before(:each) do
    @seat_incumbency_nodes = response.filter('http://id.ukpds.org/schema/SeatIncumbency').first
  end

  describe '#seats' do
    context 'Grom::Node has all the required objects' do
      it 'returns the seats for a Grom::Node object of type SeatIncumbency' do
        seat_incumbency_node = @seat_incumbency_nodes.first

        expect(seat_incumbency_node.seats.size).to eq(1)
        expect(seat_incumbency_node.seats.first.type).to eq('http://id.ukpds.org/schema/HouseSeat')
      end
    end

    context 'Grom::Node has no seats' do
      it 'returns an empty array' do
        seat_incumbency_node = @seat_incumbency_nodes[1]

        expect(seat_incumbency_node.seats).to eq([])
      end
    end
  end

  describe '#current?' do
    it 'Grom::Node returns the correct value for a current or non current seat incumbency' do
      seat_incumbency_results = @seat_incumbency_nodes.map{ |seat_incumbency| seat_incumbency.current? }

      expect(seat_incumbency_results).to eq([true, false, false, false, false])
    end
  end
end
