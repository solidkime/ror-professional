require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 5, question_id: question.id, user: user) }


  it 'mark_best' do
    5.times do
      answers.last.mark_best
      expect(answers.last.best).to eq true
      answers.first(4).each do |answer|
         expect(answer.best).to eq false
      end
    end
  end
end