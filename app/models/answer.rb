# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  
  scope :best_first, -> { order('best DESC') }

  def mark_best
    transaction do
      toggle(:best)
      question.answers.where(best: true).update_all(best: false) if best?
      save!
    end
  end
end
