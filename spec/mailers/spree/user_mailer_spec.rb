# frozen_string_literal: true

require 'spec_helper'

describe Spree::UserMailer do
  let!(:store) { create(:store, mail_from_address: 'admin@mysite.com') }
  let(:request) { create(:stock_request) }
  let(:mail) { Spree::UserMailer.back_in_stock(request) }

  it '#back_in_stock' do
    expect(mail.subject).to eq(I18n.t('spree.back_in_stock_subject', product_name: request.product.name))
    expect(mail.to).to include(request.email)
    expect(mail.from).to include('admin@mysite.com')
  end
end
