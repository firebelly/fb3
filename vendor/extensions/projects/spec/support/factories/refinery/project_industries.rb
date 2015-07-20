
FactoryGirl.define do
  factory :project_industry, :class => Refinery::Projects::ProjectIndustry do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

