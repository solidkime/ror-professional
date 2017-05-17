require 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to show appreciation and help people with the same question
  As an author of question
  I want to be able to mark best answer
  and want it to appear at the top of the answers list
} do
  given!(:user) { create(:user) }  
  given!(:question) { create(:question, user: user) }
  given!(:answer_1) { create :answer, question: question, user: user }
  given!(:answer_2) { create :answer, question: question, user: user}
  given(:old_best_answer) { create(:answer, :best, question: question,  user: user) }

  scenario 'user sees best answer', js: true do
    old_best_answer
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content '=== Best answer ==='
    end
  end

  scenario 'best answer appears on the top', js: true do
    old_best_answer
    sign_in(user)
    visit question_path(question)
    expect(page.find('.container_answer:first-child')).to have_content '=== Best answer ==='
  end

  scenario 'user marks answer as best and becomes marked and appears on top', js: true do
    sign_in(user)
    visit question_path(question)
    expect(page).not_to have_content '=== Best answer ==='
    
    within '.answers' do
      first(:button, 'Mark as best').click

      expect(page).to have_content '=== Best answer ==='

    end
    expect(page.find('.container_answer:first-child')).to have_content '=== Best answer ==='
  end

  scenario 'user marks another answer as best and it replaces previous one', js: true do
    old_best_answer
    sign_in(user)
    visit question_path(question)

    within "#answer_#{old_best_answer.id}" do
      expect(page).to have_content '=== Best answer ==='
    end

    within "#answer_#{answer_2.id}" do
      click_on 'Mark as best'
      expect(page).to have_content '=== Best answer ==='
    end
    within "#answer_#{old_best_answer.id}" do
      expect(page).not_to have_content '=== Best answer ==='
    end
  end
end
