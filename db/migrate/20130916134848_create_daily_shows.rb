class CreateDailyShows < ActiveRecord::Migration
  def change
    create_table :daily_shows do |t|
      t.string :aff
      t.integer :channel_no
      t.integer :channel_id
      t.integer :program_id
      t.string :title
      t.string :channel_name
      t.datetime :start_time
      t.integer :duration
      t.string :rep
      t.string :new
      t.string :logo
      t.string :prem
      t.datetime :finish_time
    end
  end
end

