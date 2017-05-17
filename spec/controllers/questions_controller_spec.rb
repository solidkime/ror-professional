require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) {create(:question, user: user)}

  describe "GET #index" do
    let(:questions) { create_list(:question, 2, user: user) }
    before do
      get :index
    end

    it 'populates an array of all question' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do

    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
    before {get :new}
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before {get :edit, params: {id: question}}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        post :create, params: { question: attributes_for(:question) }
        expect(question).to have_attributes(user: user) 
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:question) { build(:question, :invalid) }
      subject { post :create, params: { question: question.attributes } }

      it 'does not save the question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        #post :create, params: { question: attributes_for(:question, :invalid) }
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'user is an author of question' do
      let(:user) do
        user = create(:user)
        sign_in user
        user
      end

      let(:question) { create(:question, user: user) }

      context 'valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}, format: :js}
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update js view' do
          patch :update, params: {id: question, question: attributes_for(:question), format: :js}
          expect(response).to render_template :update
        end
      end

      context 'invalid attributes' do
        let(:request){patch :update, params: {id: question, question: {title: 'new title', body: nil}, format: :js} }

        it 'does not change attributes' do
          expect{ request }.to_not change(question, :title)
        end

        it 'renders update js view' do
          expect(request).to render_template :update
        end
      end
    end

    context 'user is not an author of question' do
      let!(:user_2) do
        user = create(:user)
        sign_in user
        user
      end

      let(:question) { create(:question, user: user) }

      it "doesn't change question" do
        patch :update, params: { id: question, question: {title: 'new_title', body: 'new body'}, format: :js }
        question.reload
        expect(question.title).to_not eq 'new_title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'if current_user is author of question' do
      sign_in_user
      it 'deletes question' do
        question = create(:question, user: @user)
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        question = create(:question, user: @user)
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'if current_user is not the author of question' do
      before do
        @user2 = create(:user)
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in @user2
      end

      it 'not deletes question' do
        question = create(:question, user: user)
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'returns 401' do
        delete :destroy, params: { id: question }
        expect(response.status).to eq 401
      end
    end
  end

  # describe 'PUT #mark_best_answer' do
  #   let(:question) { create(:question, user: user) }
  #   let(:answer) { create(:answer, user: user, question: question) }
  #   let(:user) { create(:user) }
    
  #   context 'user is an author of a question' do
  #     before do
  #       sign_in user
  #     end
  #     it 'assigns the requested question to @question' do
        
  #       put :mark_best_answer, params: { id: question, answer_id: answer, format: :js }
  #       question.reload
  #       expect(assigns(:question)).to eq question
  #     end

  #     it 'renders mark template' do
  #         sign_in user
  #         put :mark_best_answer, params: { id: question, answer_id: answer, format: :js }
  #         expect(response).to render_template :mark_best_answer
  #       end
  #     end

  #     context 'question with 3 answers' do
  #       before do
  #         sign_in user
  #       end
  #       let(:question) { create :question, :with_answers, user: user }
  #       let!(:old_best_answer) { create(:answer, :best, user: user, question: question)}
  #       let(:testing_answer) {question.answers.first}
        

  #       it 'changes answer best to true and all other answers to false' do # вомзожно стлоит разделить
  #         put :mark_best_answer, params: { id: question, answer_id: testing_answer, format: :js }
  #         question.reload
  #         testing_answer.reload
  #         old_best_answer.reload
  #         expect(testing_answer.best).to eq true
  #         expect(question.best_answer).to eq testing_answer
  #         expect(old_best_answer.best).to eq false
  #       end
  #   end
  #   context 'user is not an author of a question' do
  #     let(:user_2) { create(:user) }
  #     let(:question) { create :question, :with_answers, user: user }
  #     let!(:old_best_answer) { create(:answer, :best, user: user, question: question)}
  #     let(:testing_answer) {question.answers.first}

  #     it "doesn't change answer best to true and all other answers to false" do
  #       sign_in user_2
  #       put :mark_best_answer, params: { id: question, answer_id: testing_answer, format: :js }
  #       question.reload
  #       testing_answer.reload
  #       old_best_answer.reload
  #       expect(testing_answer.best).to eq false
  #       expect(question.best_answer).to eq old_best_answer
  #       expect(old_best_answer.best).to eq true
  #     end

  #     it 'returns 401' do
  #       put :mark_best_answer, params: { id: question, answer_id: testing_answer, format: :js }
  #       expect(response.status).to eq 401
  #     end
  #   end 
  # end
end