require 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates valid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question was sucesfully created.'
    expect(page).to have_content "text text"
  end

  scenario 'Authenticated user creates invalid question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Errors"
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Title can't be blank"
  end

    scenario 'Non-authenticated user is trying to create question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
end