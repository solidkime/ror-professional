# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  # default_scope { order(created_at: :asc) } # not my idea, but seems convinient
  scope :best_first, -> { order('best DESC') }

  def mark_best
    question.answers.where("best = ?", true).update_all(best: false)
    update!(best: true)
  end
end
