module Spree
  module OrderDecorator
    extend ActiveSupport::Concern

    included do
      after_touch :update_stock
      prepend(InstanceMethods)
    end

    module InstanceMethods
      private

      def update_stock
        recalculate
      end
    end
  end
end

Spree::Order.include(Spree::OrderDecorator)
