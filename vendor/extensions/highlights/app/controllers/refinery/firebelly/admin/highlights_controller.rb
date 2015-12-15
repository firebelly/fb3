module Refinery
  module Firebelly
    module Admin
      class HighlightsController < ::Refinery::AdminController

        crudify :'refinery/firebelly/highlight', 
                sortable: false,
                order: 'date DESC'


        private

        # Only allow a trusted parameter "white list" through.
        def highlight_params
          params.require(:highlight).permit(:date, :highlight, :link)
        end
      end
    end
  end
end
