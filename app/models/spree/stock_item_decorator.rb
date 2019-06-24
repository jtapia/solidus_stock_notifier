module Spree
  module StockItemDecorator
    extend ActiveSupport::Concern

    included do
      after_save :notify_availability
      prepend(InstanceMethods)
    end

    module InstanceMethods
      private

      def notify_availability
        return unless SolidusStockNotifier::Config.automatically_send_notification
        return if backorderable?

        orders = Spree::Order.joins(:line_items).
                              where("spree_orders.state != 'complete' AND
                                     spree_line_items.variant_id = ?", variant_id)

        orders.each do |order|
          next unless order.email

          if in_stock?
            variant.notify_waiting_list
          else
            stock_request = variant.stock_requests.find_or_create_by(email: order.email)
            stock_request&.resume! if stock_request&.notified?
          end

          order.touch
        end
      end
    end
  end
end

Spree::StockItem.include(Spree::StockItemDecorator)
