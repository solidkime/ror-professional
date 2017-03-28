require 'rails_helper'

feature "View the question and it's answers" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'Registered user can view question and answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.body
    # expect(page).to have_css("li#answer_body", count: 2)
    answers.each_with_index do |n, i|
      expect(page).to have_content answers[i].body
    end
  end

  scenario 'Guest can view question' do
    visit question_path(question)

    expect(page).to have_content question.body

    answers.each_with_index do |n, i|
      expect(page).to have_content answers[i].body
    end
  end

end