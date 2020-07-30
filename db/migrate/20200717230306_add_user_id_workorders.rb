class AddUserIdWorkorders < ActiveRecord::Migration[6.0]
  def change
    add_column :workorders, :user_id, :integer
  end
end
