require 'rails_helper'

feature 'User can destroy his or her question', %q{
  In order to be released from shame of being so silly
  As a registered user
  I want to be able to delete questions
  which I created before
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:user_2) { create(:user) }

  scenario 'Registered user deletes his own question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.body
    click_on "Destroy"
    expect(page).to have_content 'Question was succesfully deleted!'
    expect(page).not_to have_content question.body
  end

  scenario 'User tries to delete not his question' do
    sign_in(user_2)

    expect(page).to have_content question.body
    visit question_path(question)
    
    expect(page).to_not have_link 'Destroy'
  end

  scenario 'Guest tries to delete question' do
    visit question_path(question)

    expect(page).not_to have_content 'Destroy'
  end
end