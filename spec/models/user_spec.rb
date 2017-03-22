require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  it {should validate_presence_of :email}
  it {should validate_presence_of :password}

  context "author_of?" do
    it 'should return true if author matches' do
      expect(user.author_of?(question)).to eq(true)
      expect(user.author_of?(answer)).to eq(true)
    end
    it 'should return false if author not matches' do
      expect(user2.author_of?(question)).to eq(false)
      expect(user2.author_of?(answer)).to eq(false)
    end
  end
end
