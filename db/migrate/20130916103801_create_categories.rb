class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, :id=>false do |t|
      t.integer :id,  :null => false
      t.integer :msn_id
      t.string :name
    end
    add_index :categories,:id, :unique => true
  end
end
