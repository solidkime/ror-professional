# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  
  scope :best_first, -> { order('best DESC') }

  def mark_best
    transaction do
      toggle(:best)
      question.answers.where(best: true).update_all(best: false) if best?
      save!
    end
  end
end
