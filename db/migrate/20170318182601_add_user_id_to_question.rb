class AddUserIdToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :user, index: true
  end
end
