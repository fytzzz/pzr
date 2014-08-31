class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :price
      t.string :img
      t.integer :user_id
      t.integer :seqence,:default => 0
      t.integer :visible, :default => 1
      t.timestamps
    end
  end
end
