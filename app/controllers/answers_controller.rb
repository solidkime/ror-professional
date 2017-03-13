# frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :new]
  before_action :load_question, only: [:new, :create]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end


  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answer_url(@question, @answer)
    else
      render :new
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