module Refinery
  module Firebelly
    class Highlight < Refinery::Core::BaseModel

      def title
        ActionController::Base.helpers.strip_tags highlight
      end

      # acts_as_indexed :fields => [:title]

    end
  end
end
