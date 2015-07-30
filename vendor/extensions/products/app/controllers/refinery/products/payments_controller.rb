module Refinery
  module Products
    class ProductsController < ::ApplicationController

      def paypal_ipn
        if request.method == 'POST'
          PaypalRecord.create(:params => params)
        end
        
        render :text => "OK"
      end
      
    end
  end
end