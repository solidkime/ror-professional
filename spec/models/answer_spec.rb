require 'rails_helper'



RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to :user }
  it { should have_many :attachments}
  it { should accept_nested_attributes_for :attachments}
  
  it { should validate_presence_of :body }

  describe 'scoping' do
    let(:user) { create(:user) }
    let!(:question) { create :question, user: user }
    let!(:answer_1) { create :answer, question: question, user: user }
    let!(:answer_2) { create :answer, question: question, user: user, best: true }
    let!(:answer_3) { create :answer, question: question, user: user }

    it 'scopes best answer as first' do
      expect( Answer.best_first.first ).to eq answer_2
    end
  end
end