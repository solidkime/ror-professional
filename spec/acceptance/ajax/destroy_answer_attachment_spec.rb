require 'acceptance_helper'

feature 'User can destroy his or her attachment', %q{
  In order to be released from shame of being so silly,
  and destroy evidence of me posting anime-pictures
  As a registered user
  I want to be able to delete attachments
  which I created before
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user)}
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:user_2) { create(:user) }

  scenario 'Registered user deletes his attachment to answer', js: true  do
    sign_in(user)

    visit question_path(question)
    within '.container_attachment' do
      expect(page).to have_link 'spec_helper.rb'
      click_on 'Destroy attachment'
    end
    expect(page).to have_content 'Attachment was successfully deleted'
    expect(page).not_to have_link 'spec_helper.rb'
  end

  scenario 'User tries to delete attachment to not his answer' do
    sign_in(user_2)
    visit question_path(question)
    within '.container_attachment' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to_not have_link 'Destroy'
    end
  end

  scenario 'Guest tries to delete answer attachment' do
    visit question_path(question)
    within '.container_attachment' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).not_to have_content 'Destroy'
    end
  end


end