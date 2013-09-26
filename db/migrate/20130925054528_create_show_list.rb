class CreateShowList < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title
      t.integer :program_id
      t.string :lead_actors
      t.text :description
      t.string :directors
      t.string :episode_title
      t.string :other_credits
      t.string :lead_host
      t.string :hosts
      t.string :actors
      t.string :mpaa
      t.string :star_rating
      t.string :year
    end
    add_index :shows, :program_id, :unique => true
  end
end

