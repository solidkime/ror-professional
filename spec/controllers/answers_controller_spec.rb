require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }


 
  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user: user, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'creates association with current_user' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user: user, format: :js } }.to change(@user.answers, :count).by(1)
        #expect(user.questions.count).to eq 0
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
      
    end
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, user: user, format: :js } }.to_not change(Answer, :count)
      end

      it 'rerenders create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, user: user, format: :js } 
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
      let!(:user_2) do
        user = create(:user)
        sign_in user
        user
      end

      it 'not deletes answer' do
        answer
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'renders show view' do
        delete :destroy, params: { id: answer }
        expect(response).to render_template :show
      end
    end
  end

  describe 'PATCH #update' do

    context 'if current_user is an author of answer' do
      let(:user) do
        user = create(:user)
        sign_in user
        user
      end

      let(:answer) { create(:answer, user: user, question: question) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template for updated question' do
        patch :update, params: {id: answer, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'if current_user is not an author of answer' do
      # before do
      #   @user2 = create(:user)
      #   @request.env['devise.mapping'] = Devise.mappings[:user]
      #   sign_in @user2
      # end
      let!(:user_2) do
        user = create(:user)
        sign_in user
        user
      end

      let(:answer) { create(:answer, user: user, question: question) }

      it "doesn't change answer" do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end
end