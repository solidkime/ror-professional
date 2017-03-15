require 'rails_helper'

feature 'User watch questions list', %q{
  in order to chose question
  As a user or guest
  I want to be able to see a list of all questions
} do
  let(:user) { create(:user) }
  
  scenario 'Guest trying to watch list of all questions' do
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'List of questions'
    expect(page).to have_content 'Title'
  end

  scenario 'Registered user trying to watch list of all questions' do
    sign_in(user)
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'List of questions'
    expect(page).to have_content 'Title'

  end
end