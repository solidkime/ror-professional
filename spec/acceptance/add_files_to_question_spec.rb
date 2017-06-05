require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
  

  scenario 'Authenticated user create multiple attachments for question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    #save_and_open_page 
    click_on 'Create'
  end
end

# scenario 'Authenticated user create multiple attachments for question', js: true do
#     fill_in 'Title', with: 'Test question'
#     fill_in 'Body', with: 'text text'

#     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
#     click_on 'add attachment'
#     page.all(:css, 'input[type="file"]').each do |el|
#       el.set "#{Rails.root}/spec/spec_helper.rb"
#     end
#     click_on 'Create'

#     within '.question-container' do
#       expect(page).to have_link 'spec_helper', count: 2
#     end
#   end