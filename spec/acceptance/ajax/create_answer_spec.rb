require 'acceptance_helper'

feature 'Create answer', %q{
  In order to help a person, who asked a question
  As an authenticated user
  I want to be able to answer a questions
} do

  given(:user) { create(:user) }  
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates valid answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Comment', with: 'omg omg'
    click_on 'Create'

    expect(page).to have_content "omg omg"
    expect(page).to have_content "Thank you for answer!" 
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Comment', with: ''
    click_on 'Create'

    expect(page).to have_content "Errors"
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Answer is wrong"
  end

  scenario 'Non-authenticated user is trying to create answer', js: true  do
    visit question_path(question)
    expect(page).to have_content "You should log in to leave comments"
  end
end