FactoryGirl.define do

  sequence :body do |n|
    "TestAnsText#{n}"
  end

  factory :answer do
    body
    question
    user
      
    trait :best do
      best :true
    end
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
