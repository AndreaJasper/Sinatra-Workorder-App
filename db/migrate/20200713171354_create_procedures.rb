class CreateProcedures < ActiveRecord::Migration[6.0]
  def change
    create_table :procedures do |t|
      t.string :name
      t.string :content
      t.string :workorder_id
      t.string :asset_id
    end
  end
end
