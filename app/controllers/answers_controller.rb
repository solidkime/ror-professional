  # frozen_string_literal: true
class AnswersController < ApplicationController
  before_action :load_answer, only: [:show, :new, :destroy]
  before_action :load_question, only: [:new, :create]

  def index
    @answers = Answer.all
  end

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    # @answer = Answer.new(answer_params)
    # @answer.question = @question
    # @answer.user = current_user
    # @answer.save

    # if @answer.save
    #  redirect_to @question, notice: 'Thank you for answer!'
    # else
    #   render "questions/show"
    # end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: 'Answer was succesfully deleted!'
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
