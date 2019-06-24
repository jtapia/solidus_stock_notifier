# frozen_string_literal: true

module SolidusStockNotifier
  class Configuration < Spree::Preferences::Configuration
    preference :automatically_send_notification, :boolean, default: true
  end
end
