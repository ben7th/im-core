FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "tag-#{n}" }
    faq
    reference
  end
end
