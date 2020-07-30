class CreateWorkorders < ActiveRecord::Migration[6.0]
  def change
    create_table :workorders do |t|
      t.string :name
      t.string :asset_id
    end
  end
end
