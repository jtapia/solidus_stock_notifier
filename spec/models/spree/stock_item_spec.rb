# frozen_string_literal: true

require 'spec_helper'

describe Spree::StockItem, type: :model do
  let!(:order) { create(:order_with_line_items) }
  let(:stock_item) do
    create(:stock_item, variant: order.line_items.first.variant)
  end

  before do
    stock_item.variant.stock_requests.delete_all
  end

  context 'available to send notifications' do
    before do
      allow(stock_item).to receive(:backorderable?).and_return(false)
      stock_item.adjust_count_on_hand(-10)
    end

    it 'creates a stock request' do
      expect(stock_item.variant.stock_requests.count).to eq(1)
    end
  end

  context 'not available to send notifications' do
    before do
      allow(stock_item).to receive(:backorderable?).and_return(true)
      stock_item.adjust_count_on_hand(-10)
    end

    it "can't create a stock request based on backorderable ability" do
      expect(stock_item.variant.stock_requests.count).to be(0)
    end

    it "can't create a stock request based on config ability" do
      allow(stock_item).to receive(:backorderable?).and_return(false)
      allow(SolidusStockNotifier::Config).
        to receive(:automatically_send_notification).and_return(false)
      expect(stock_item.variant.stock_requests.count).to be(0)
    end
  end
end
