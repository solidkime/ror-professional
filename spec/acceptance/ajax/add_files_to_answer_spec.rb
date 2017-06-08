require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Comment:', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'Authenticated user create multiple attachments for question', js: true do
    within '.new_answer' do
      fill_in 'Comment', with: 'Test answer'
      # attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'add attachment'
      page.all(:css, 'input[type="file"]').each do |el|
        el.set "#{Rails.root}/spec/spec_helper.rb"
      end
    end
    click_on 'Create answer'
    within '.answers' do
      expect(page).to have_link 'spec_helper', count: 2
    end
  end
end