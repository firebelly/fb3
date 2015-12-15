require 'spec_helper'

module Refinery
  module Firebelly
    describe Highlight do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:highlight)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
