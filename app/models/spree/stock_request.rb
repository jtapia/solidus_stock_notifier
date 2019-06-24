module Spree
  class StockRequest < ActiveRecord::Base
    belongs_to :variant
    delegate :product, to: :variant

    validates :email, presence: true,
              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

    scope :notified, -> { where(status: 'notified') }
    scope :not_notified, -> { where(status: 'new') }

    state_machine :status, initial: 'new' do
      event :notify do
        transition from: 'new', to: 'notified'
      end

      event :resume do
        transition from: 'notified', to: 'new'
      end

      after_transition to: 'notified', do: :send_email
    end

    private

    def send_email
      Devise.mailer.back_in_stock(self).deliver
    end
  end
end
