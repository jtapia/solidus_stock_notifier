# frozen_string_literal: true

require 'spec_helper'

describe Spree::StockRequest do
  subject { create(:stock_request) }

  it { expect(subject).to be_valid }
  it { expect(subject.status).to eq('new') }

  it 'should validate email' do
    subject.email = 'garbage'
    subject.valid?

    expect(subject.errors[:email].size).to eq(1)
  end

  context 'notification' do
    before do
      mail = double(:mail)
      expect(Spree::UserMailer).to receive(:back_in_stock).with(subject).
        and_return(mail)
      expect(mail).to receive(:deliver)
      subject.notify!
    end

    it { expect(subject.status).to eql('notified') }
    it { expect(Spree::StockRequest.not_notified.size).to eq(0) }
    it { expect(Spree::StockRequest.notified.size).to eq(1) }
  end
end
