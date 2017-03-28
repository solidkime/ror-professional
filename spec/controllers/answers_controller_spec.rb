require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }


 
  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(answer).to have_attributes(user: user)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
      
    end
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end
      it 'rerenders create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } 
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #destroy' do
    context 'if current_user is author of answer' do
      sign_in_user
      it 'deletes answer' do
        answer = create(:answer, user: @user, question: question)
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
      it 'redirects to index view' do
        answer = create(:answer, user: @user, question: question)
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'if current_user is not an author of answer' do
      before do
        @user2 = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in @user2
      end

      it 'not deletes answer' do
        answer
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'renders show view' do
        delete :destroy, params: { id: answer }
        expect(response).to render_template :show
        should set_flash.now[:alert].to('Sorry, you can delete only your answers.')
      end
    end
  end
end