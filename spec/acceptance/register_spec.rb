require 'rails_helper'

feature 'Sign up', %q{
  In order to use all features,
  user can register witin special page
} do

  scenario 'Guest trying to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Guest trying to register with invalid data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '1'
    fill_in 'Password confirmation', with: '12'
    click_on 'Sign up'
    expect(page).to have_content 'prohibited this user from being saved'
  end

end