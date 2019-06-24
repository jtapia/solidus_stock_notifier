module Spree
  class StockRequestsController < Spree::StoreController
    # layout false

    def new
      @stock_request = Spree::StockRequest.new
    end

    def create
      @stock_request = Spree::StockRequest.new(stock_request_params)
      @stock_request.email = try_spree_current_user.email if try_spree_current_user

      if @stock_request.save
        respond_to do |format|
          format.html { redirect_to root_path, notice: t('spree.successful_stock_request') }
          format.json { render json: { message: t('spree.successful_stock_request') }, status: 201 }
          format.js
        end
      else
        respond_to do |format|
          format.html { render action: 'new'}
          format.json { render json: @stock_request.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def stock_request_params
      params.require(:stock_request).permit(:email, :variant_id)
    end
  end
end
