# frozen_string_literal: true
class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_one :best_answer, -> { where(best: true) }, class_name: 'Answer'

  validates :title, :body, presence: true

end
