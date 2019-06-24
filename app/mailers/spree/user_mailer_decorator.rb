module UserMailerDecorator
  extend ActiveSupport::Concern

  included do
    prepend(InstanceMethods)
  end

  module InstanceMethods
    def back_in_stock(stock_request)
      @store = Spree::Store.default
      @variant = stock_request.variant
      @product = @variant.product
      mail(to: stock_request.email,
           from: from_address(@store),
           subject: t('spree.back_in_stock_subject', product_name: @product.name))
    end
  end
end

Spree::UserMailer.include(UserMailerDecorator)
