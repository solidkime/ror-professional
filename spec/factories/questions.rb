FactoryGirl.define do

  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title
    body "BodyText"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

end