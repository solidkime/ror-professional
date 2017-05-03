require 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to show appreciation and help people with the same question
  As an author of question
  I want to be able to mark best answer
  and want it to appear at the top of the answers list
} do
  given!(:user) { create(:user) }  
  given!(:question) { create(:question, user: user) }
  given!(:answer_1) { create :answer, question: question, user: user }
  given!(:answer_2) { create :answer, question: question, user: user, best: true }
  given!(:answer_3) { create :answer, question: question, user: user }

  scenario 'author marks answer as best', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      first(:link, 'Mark as best').click 
      expect(page).to have_content `=== Best answer ===`
    end
  end





end