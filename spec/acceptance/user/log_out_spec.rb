require 'acceptance_helper'

feature 'log out', %q{
  In order to be able to lose user features
  As an user
  I want to be able to sign out
} do
  let(:user) { create(:user) }
  scenario 'Registered user trying to log out' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'
    expect(page).to have_content "Signed out successfully."
  end
end