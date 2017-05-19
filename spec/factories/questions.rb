FactoryGirl.define do

  sequence :title do |n|
    "Title#{n}"
  end

  factory :question do
    title
    body "BodyText"
    user

    trait :with_answers do
      transient do
        answers_count 3
      end
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end

    trait :invalid do
      title nil
      body nil
    end
  end
end