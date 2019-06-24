class CreateSpreeStockRequestsTable < SolidusSupport::Migration[4.2]
  def change
    unless table_exists?('spree_stock_requests')
      create_table :spree_stock_requests do |t|
        t.string :email
        t.references :variant, index: true
        t.string :status, default: 'new'

        t.timestamps
      end
    end
  end
end
