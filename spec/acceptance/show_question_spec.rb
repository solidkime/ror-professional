require 'rails_helper'

feature "View the question and it's answers" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'Registered user can view question and answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.body
    # expect(page).to have_css("li#answer_body", count: 2)
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body

  end

  scenario 'Guest can view question' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end

end