require 'rails_helper'

feature 'User can destroy his or her answer', %q{
  In order to be released from shame of being so silly
  As a registered user
  I want to be able to delete answers
  which I created before
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) {create(:answer, user: user, question: question)}
  given(:user_2) { create(:user) }

  scenario 'Registered user deletes his own answer' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content answer.body
    click_on "Destroy answer"
    expect(page).to have_content 'Answer was succesfully deleted!'
    expect(page).not_to have_content answer.body
  end

  scenario 'User tries to delete not his answer' do
    sign_in(user_2)

    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Destroy answer'

    # expect(page).to have_content 'Sorry, you can delete only your answers.'
  end

  scenario 'Guest tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Destroy answer'
  end
end