module Spree
  module VariantDecorator
    extend ActiveSupport::Concern

    included do
      has_many :stock_requests
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def waiting_list
        stock_requests.not_notified
      end

      def notify_waiting_list
        waiting_list.each(&:notify!)
      end
    end
  end
end

Spree::Variant.include(Spree::VariantDecorator)
