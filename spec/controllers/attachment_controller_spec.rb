require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do
    
    context 'if current_user is author of attachment' do
      sign_in_user
      let(:question) {create(:question, user: @user)}
      let(:attachment) {create(:attachment, attachable: question)}

      it 'deletes attachment' do
        attachment
        expect { delete :destroy, params: { id: attachment, format: :js } }.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy js' do
        attachment
        delete :destroy, params: { id: attachment, format: :js }
        expect(response).to render_template :destroy
      end

    end





  end












end

