require 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to edit my answer
} do

  given(:user) { create(:user) }  
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:user_2) { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      answer
      visit question_path(question)
    end

    scenario 'sees Edit' do
       within '.answers' do
        expect(page).to have_link 'Edit'
       end
    end

    scenario 'Author try to edit his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'
        
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  # Это пришлось вынечти, иначе нужно ради этого теста перекручивать гивен и бифор ду и писать много лишнего кода
  scenario "Authenticated user tries to edit another user's answer" do
      sign_in(user_2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end