require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As and authenticated user
  I want to be able to ask questions
} do

  let(:user) { create(:user) }

  scenario 'Authenticated user creates question' do

    visit new_user_session_path #'/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'


    expect(page).to have_content 'Your question was sucesfully created.'
  end

    scenario 'Non-authenticated user is trying to create question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content "You need to sign in or sign up before continuing."
    end
end