  # frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :new, :destroy]
  before_action :load_question, only: [:new, :create, :destroy]

  def index
    @answers = Answer.all
  end

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Thank you for answer!'
      # redirect_to question_answer_url(@question, @answer)
    else
      @question.reload
      render "questions/show"
    end
  end

  def destroy
    if @answer.user.id == current_user.id
      @answer.destroy
      redirect_to questions_path, notice: 'Answer was succesfully deleted!'
    else
      flash.now[:alert] = 'Sorry, you can delete only your answers.'
      render 'questions/show'
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
