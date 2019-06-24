# frozen_string_literal: true

require 'spec_helper'

describe Spree::StockRequestsController, type: :controller do
  let(:user) { create(:user_with_addresses) }
  let!(:variant) { create(:master_variant) }

  before do
    allow(controller).to receive_messages(try_spree_current_user: nil)
  end

  it '#new' do
    get :new, params: { stock_request: { variant_id: variant.id }}
    expect(response).to be_success
  end

  context '#create' do
    context 'valid data' do
      it 'html format' do
        post :create,  params: { stock_request: { email: 'user@gmail.com', variant_id: variant.id }}
        expect(response).to redirect_to(spree.root_path)
        expect(flash[:notice]).to eql(Spree.t(:successful_stock_request))
        expect(Spree::StockRequest.where(email: 'user@gmail.com').first).to_not be_nil
      end

      it 'js format' do
        post :create,  params: { stock_request: { email: 'user@gmail.com', variant_id: variant.id }}, format: :js
        expect(response).to be_success
        expect(response).to render_template('create')
      end

      it 'json format' do
        post :create, params: { stock_request: { email: 'user@gmail.com', variant_id: variant.id }}, format: :json
        expect(response).to be_success
        expect(json_response[:message]).to eq(Spree.t(:successful_stock_request))
      end

      context 'logged in' do
        before do
          allow(controller).to receive_messages(try_spree_current_user: user)
        end

        it 'should set email' do
          post :create,  params: { stock_request: { variant_id: variant.id }}
          expect(Spree::StockRequest.where(email: user.email).first).to_not be_nil
        end
      end
    end

    context 'invalid data' do
      it 'raises an exception' do
        expect { post :create }.to raise_error ActionController::ParameterMissing
      end

      context 'show messages validation' do
        it 'html format' do
          post :create,  params: { stock_request: { email: 'user' }}
          expect(response).to render_template('new')
        end

        it 'json format' do
          post :create,  params: { stock_request: {email: 'user' }}, format: :json
          expect(response.status).to eql(Rack::Utils::SYMBOL_TO_STATUS_CODE[:unprocessable_entity])
        end
      end
    end
  end

  def json_response
    case body = JSON.parse(response.body)
      when Hash
        body.with_indifferent_access
      when Array
        body
    end
  end
end
