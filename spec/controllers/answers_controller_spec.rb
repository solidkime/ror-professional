require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }


  # describe "GET #index" do
  #   sign_in_user

  #   let(:answers) { create_list(:answer, 2, question: question, user: user) }
  #   before do
  #     get :index, params: { question_id: question }
  #   end

  #   it 'populates an array of all answers' do
  #     expect(assigns(:answers)).to match_array(answers)
  #   end

  #   it 'renders index view' do
  #     expect(response).to render_template :index
  #   end
  # end

  # describe "GET #show" do
  #   sign_in_user

  #   before { get :show, params: { id: answer, question_id: question } }

  #   it 'assigns the requested question to @answer' do
  #     expect(assigns(:answer)).to eq answer
  #   end

  #   it 'renders show view' do
  #     expect(response).to render_template :show
  #   end
  # end

  # describe "GET #new" do
  #   sign_in_user
    
  #   before { get :new, params: { id: answer, question_id: question } }
  #   it 'assigns a new Answer to @answer' do
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end

  #   it 'renders new view' do
  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(answer).to have_attributes(user: user)
      end

      it 'redirects to @question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
      # it 'redirects to show view' do
      #   post :create, params: { answer: attributes_for(:answer), question_id: question }
      #   expect(response).to redirect_to question_answer_path(question, assigns(:answer))
      # end
    end
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } 
        expect(response).to render_template :show
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