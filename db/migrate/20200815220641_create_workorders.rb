class CreateWorkorders < ActiveRecord::Migration[6.0]
  def change
    create_table :workorders do |t|
      t.string :name
      t.text :description
      t.integer :multiplier
      t.integer :hours_needed
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
