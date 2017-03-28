class AddUserIdToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_reference :answers, :user, index: true
  end
end
