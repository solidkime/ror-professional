  require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'best answer returns answer with best attribute set to true' do
    let(:user) { create(:user) }
    let(:question) { create :question, user: user }
    let!(:answer) { create :answer, user: user, question: question, best: true }
    let(:answer_2) { create :answer, user: user, question: question}
    let(:answer_3) { create :answer, user: user, question: question}

    it 'returns best answer' do
      expect(question.best_answer).to eq answer
    end
  end
end



