require 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to edit my question
} do
  given(:user) { create(:user) }  
  given!(:question) { create(:question, user: user) }
  given(:user_2) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees Edit' do
      within '.question-container' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'Author tries to edit his question', js: true do
      click_on 'Edit'
      within '.edit_question' do
        fill_in 'Question', with: 'edited question'
        click_on 'Save'
      end
      within '.question-container' do
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "Authenticated user tries to edit another user's question" do
    sign_in(user_2)
    visit question_path(question)
    within '.question-container' do
      expect(page).to_not have_link 'Edit'
    end
  end
  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)
    within '.question-container' do
      expect(page).to_not have_link 'Edit'
    end
  end
end