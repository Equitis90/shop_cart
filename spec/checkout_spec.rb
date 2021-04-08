require 'spec_helper'
require_relative '../checkout'

describe 'Checkout testing' do
  let(:item_001) { Item.new(code: '001', name: 'Red Scarf', price: 9.25) }
  let(:item_002) { Item.new(code: '002', name: 'Silver cufflinks', price: 45.00) }
  let(:item_003) { Item.new(code: '003', name: 'Silk Dress', price: 19.95) }
  let(:co) do
    Checkout.new({
                   total_discount: { amount: 60, percent: 0.1 },
                   "001": { discount_threshold: 2, discounted_price: 8.50 }
                 }
                )
  end

  context 'added each item' do
    before do
      co.scan(item_001)
      co.scan(item_002)
      co.scan(item_003)
    end

    it 'calculates discount' do
      expect(co.total).to eq 66.78
    end
  end

  context 'added two scarfs and a dress' do
    before do
      co.scan(item_001)
      co.scan(item_003)
      co.scan(item_001)
    end

    it 'calculates discount' do
      expect(co.total).to eq 36.95
    end
  end

  context 'added two scarfs, cufflinks and a dress' do
    before do
      co.scan(item_001)
      co.scan(item_002)
      co.scan(item_001)
      co.scan(item_003)
    end

    it 'calculates discount' do
      expect(co.total).to eq 73.76
    end
  end
end
