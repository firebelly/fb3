require 'spec_helper'

module Refinery
  module Projects
    describe ProjectIndustry do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:project_industry,
          :name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:name) { should == "Refinery CMS" }
      end
    end
  end
end
