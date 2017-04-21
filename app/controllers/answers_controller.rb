  # frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :destroy, :update]
  before_action :load_question, only: [:new, :create]

  def index
    @answers = Answer.all
  end

  def show; end

  def new
    #@answer = @question.answers.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    @answer.save

    if @answer.save
      flash[:notice] = 'Thank you for answer!'
    else
      flash[:notice] = 'Answer is wrong'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: 'Answer was succesfully deleted!'
    else
      render :nothing => true, :status => 401
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
