require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

#   context "author_of?" do
#     it 'should return true if author matches' do
#       expect(user.author_of?(question)).to eq(true)
#       expect(user.author_of?(answer)).to eq(true)
#     end
#     it 'should return false if author not matches' do
#       expect(user2.author_of?(question)).to eq(false)
#       expect(user2.author_of?(answer)).to eq(false)
#     end
#   end
# end

  describe "#author_of?" do
    let(:user) { build_stubbed :user }
    let(:target) { double }

    it "returns true when author" do
      allow(target).to receive(:user_id).and_return user.id
      expect(user.author_of?(target)).to eq true
    end
    
  end

  
end
