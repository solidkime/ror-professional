# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  belongs_to :user
  
  # scope :best_answer, -> { answers.where(best: true).last }

  validates :title, :body, presence: true


  def best_answer
    answers.find_by(best: true)
  end

end
