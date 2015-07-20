
FactoryGirl.define do
  factory :news_post, :class => Refinery::NewsPosts::NewsPost do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

