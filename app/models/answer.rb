# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def make_best
    question.answers.where("best = ?", true).update_all(best: false)
    update!(best: true)
  end
end
