FactoryGirl.define do
  factory :answer do
    body "TesnAnsText"
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
