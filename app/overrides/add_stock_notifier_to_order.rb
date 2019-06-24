# frozen_string_literal: true

Deface::Override.new(
  virtual_path: 'spree/orders/_line_item',
  name: 'add_stock_notifier_to_cart_form',
  insert_after: '.out-of-stock',
  partial: 'spree/shared/stock_notifier_link',
  disabled: false
)
