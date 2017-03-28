require 'rails_helper'

feature 'User watch questions list', %q{
  in order to chose question
  As a user or guest
  I want to be able to see a list of all questions
  I want to be able to chose question
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }
  given(:first_question) {questions[0]}
  
  scenario 'Guest trying to watch list of all questions' do
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'List of questions'
    expect(page).to have_content 'Title'

    questions.each_with_index do |n, i|
      expect(page).to have_content questions[i].title
    end
  end

  scenario 'Guest trying to chose question to watch' do
    visit questions_path
    first(:link, 'show').click
    expect(current_path).to eq question_path(first_question)
  end


  scenario 'Registered user trying to watch list of all questions' do
    sign_in(user)
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'List of questions'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'show'

    questions.each_with_index do |n, i|
      expect(page).to have_content questions[i].title
    end

    first(:link, 'show').click
    expect(current_path).to eq question_path(first_question)
  end

  scenario 'Registered user trying to chose question to watch' do
    sign_in(user)
    visit questions_path
    first(:link, 'show').click
    expect(current_path).to eq question_path(first_question)
  end
end