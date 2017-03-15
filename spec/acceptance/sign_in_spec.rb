require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do
  let(:user) { create(:user) }

   scenario 'Registered user trying to sign in' do
    sign_in(user)
    # save_and_open_page
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
   end

   scenario 'Non-registered user trying to sign in' do
    visit new_user_session_path #'/sign_in'
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path

   end
end