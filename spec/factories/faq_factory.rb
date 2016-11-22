FactoryGirl.define do
  factory :faq do
    sequence :question do |n|
      "faq#{n}"
    end
    sequence :answer do |n|
      "faq#{n}"
    end
    reference
    tag
  end
end