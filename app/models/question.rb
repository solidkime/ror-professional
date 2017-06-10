# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  belongs_to :user
  
  # scope :best_answer, -> { answers.where(best: true).last }

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank


  def best_answer
    answers.find_by(best: true)
  end

end
