FactoryGirl.define do
  factory :reference do
    sequence :name do |n|
      "reference#{n}"
    end
    describe "文学巨著"
    sequence :kind do |n|
      "kind#{n}"
    end
    tag
  end
  
end