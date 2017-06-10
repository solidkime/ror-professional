  # frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :destroy, :update]
  before_action :load_question, only: [:new, :create, :mark_best]

  def index
    @answers = Answer.all
  end

  def show; end

  def new
    #@answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge(question: @question, user: current_user))

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
    else
      head :forbidden
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def mark_best
    if current_user.author_of?(@question)
      @answer = Answer.find(params[:id])
      @answer.mark_best
    else
      head :forbidden
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy] )
  end
end
