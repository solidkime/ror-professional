# frozen_string_literal: true
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  # default_scope { order(created_at: :asc) } # not my idea, but seems convinient
  # default_scope { order('best DESC') }
  scope :best_first, -> { order('best DESC') }

  # def mark_best
  #   ActiveRecord::Base.transaction do
  #     question.answers.where("best = ?", true).update_all(best: false)
  #     #self.update(best: true)
  #     question.answers.where(id: self.id).update_all(best: true)
  #     self.best = true
  #     # Answer.where(question_id: question.id, best: true).update(best: false)
  #     #Answer.where(question: question).update_all(best: false)
  #     #question.answers.where.not(id: self.id).update_all(best: false)
  #   end
  # end


  # def mark_best
  #   ActiveRecord::Base.transaction do
  #     question.answers.update(best: false)
  #     self.update(best: true)
  #   end
  # end
  def mark_best
    transaction do
      question.answers.update(best: false)
      self.update!(best: true)
    end
  end

end
