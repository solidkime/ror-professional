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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
      it 'redirects to index view' do
        answer = create(:answer, user: @user, question: question)
        delete :destroy, params: {id: answer}, format: :js
        expect(response).to render_template :destroy
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end

      it 'returns 403' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq 403
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
        expect(response.status).to eq 403
      end
    end
  end
  
  describe 'PUT #mark_best_answer' do
    let(:user) { create(:user) }
    #let(:question) { create(:question, user: user) }
    let(:question) { create :question, :with_answers, user: user }
    #let(:answer) { create(:answer, user: user, question: question) }
    let!(:old_best_answer) { create(:answer, :best, user: user, question: question)}
    let(:testing_answer) {question.answers.first}
    
    
    context 'user is an author of a question' do
      before {sign_in user}

      subject do
        put :mark_best, params: { id: testing_answer, question_id: testing_answer.question, format: :js }
        question.reload
        testing_answer.reload
        old_best_answer.reload
      end
        
      it 'assigns the requested question to @question' do
        put :mark_best, params: { id: testing_answer, question_id: question, format: :js }
        question.reload
        expect(assigns(:question)).to eq question
        expect(assigns(:answer)).to eq testing_answer
      end

      it 'renders mark template' do
        sign_in user
        put :mark_best, params: { id: testing_answer, question_id: question, format: :js }
        expect(response).to render_template :mark_best
      end

      it 'changes answer best to true and all other answers to false' do
          subject
          expect(testing_answer.best).to eq true
        end

      it 'changes old best answer to false' do
        subject
        # я бы все же сделал 2 экспекта или как-то красиво проверил массив, но не знаю как
        expect(old_best_answer.best).to eq false
        expect(question.answers[1].best).to eq false
      end

    end

    context 'user is not an author of a question' do
      let(:user_2) { create(:user) }
      let(:question) { create :question, :with_answers, user: user }
      let!(:old_best_answer) { create(:answer, :best, user: user, question: question)}
      let(:testing_answer) {question.answers.first}

      subject do
        sign_in user_2
        put :mark_best, params: { id: testing_answer, question_id: testing_answer.question, format: :js }
        testing_answer.reload
        old_best_answer.reload
      end

      it "testing answer don't become best" do
        subject
        expect(testing_answer.best).to eq false
      end

      it "old best answer is still the best" do
        subject
        expect(old_best_answer.best).to eq true
      end

      it 'returns 403' do
        subject
        expect(response.status).to eq 403
      end
    end 
  end
end